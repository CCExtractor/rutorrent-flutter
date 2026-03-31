import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.logger.dart';

Logger _log = getLogger("DiscoveryService");

/// Represents a discovered ruTorrent server on the local network.
class DiscoveredServer {
  final String host;
  final int port;
  final String protocol;
  final String? name;

  DiscoveredServer({
    required this.host,
    required this.port,
    this.protocol = 'http',
    this.name,
  });

  /// Constructs the full URL for connecting to this server.
  String get url {
    if (port == 80 && protocol == 'http') {
      return '$protocol://$host';
    } else if (port == 443 && protocol == 'https') {
      return '$protocol://$host';
    }
    return '$protocol://$host:$port';
  }

  @override
  String toString() => name != null ? '$name ($url)' : url;
}

/// Service for discovering ruTorrent servers on the local network
/// using mDNS/DNS-SD (Zeroconf).
///
/// This service broadcasts mDNS queries for the `_rutorrent_mobile._tcp.local`
/// service type and listens for responses from servers that have been
/// configured to advertise via Avahi or similar mDNS responders.
///
/// ## Server Configuration
/// To make a ruTorrent server discoverable, users need to create an Avahi
/// service file on their server. Example `/etc/avahi/services/rutorrent.service`:
/// ```xml
/// <?xml version="1.0" standalone='no'?>
/// <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
/// <service-group>
///   <name>My ruTorrent Server</name>
///   <service>
///     <type>_rutorrent_mobile._tcp</type>
///     <port>443</port>
///     <txt-record>protocol=https</txt-record>
///   </service>
/// </service-group>
/// ```
class DiscoveryService {
  static const String _serviceType = '_rutorrent_mobile._tcp.local';
  static const int _mdnsPort = 5353;
  static const String _mdnsAddress = '224.0.0.251';
  static const Duration _discoveryTimeout = Duration(seconds: 5);

  final ValueNotifier<List<DiscoveredServer>> discoveredServers =
      ValueNotifier([]);
  final ValueNotifier<bool> isDiscovering = ValueNotifier(false);

  /// Starts discovering ruTorrent servers on the local network.
  ///
  /// Sends an mDNS query for the `_rutorrent_mobile._tcp.local` service type
  /// and listens for responses for [timeout] duration (default 5 seconds).
  ///
  /// Returns a list of discovered servers.
  Future<List<DiscoveredServer>> discover({Duration? timeout}) async {
    final effectiveTimeout = timeout ?? _discoveryTimeout;
    isDiscovering.value = true;
    discoveredServers.value = [];

    _log.i('Starting mDNS discovery for $_serviceType');

    try {
      // Bind to the mDNS multicast address
      final socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0, // Let OS pick a port
      );

      // Join the multicast group
      socket.joinMulticast(InternetAddress(_mdnsAddress));
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;

      // Build and send the mDNS query
      final query = _buildMdnsQuery(_serviceType);
      socket.send(
        query,
        InternetAddress(_mdnsAddress),
        _mdnsPort,
      );

      _log.i('mDNS query sent, listening for responses...');

      // Collect responses
      final List<DiscoveredServer> servers = [];
      final completer = Completer<List<DiscoveredServer>>();

      // Set up timeout
      Timer(effectiveTimeout, () {
        if (!completer.isCompleted) {
          socket.close();
          completer.complete(servers);
        }
      });

      // Listen for responses
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            try {
              final server = _parseMdnsResponse(datagram);
              if (server != null &&
                  !servers.any((s) => s.host == server.host && s.port == server.port)) {
                servers.add(server);
                _log.i('Discovered server: ${server.url}');
                discoveredServers.value = List.from(servers);
              }
            } catch (e) {
              _log.w('Error parsing mDNS response: $e');
            }
          }
        }
      });

      final result = await completer.future;

      _log.i('Discovery complete. Found ${result.length} server(s).');

      discoveredServers.value = result;
      isDiscovering.value = false;
      return result;
    } catch (e) {
      _log.e('Discovery failed: $e');
      isDiscovering.value = false;
      return [];
    }
  }

  /// Builds a minimal mDNS query packet for the given service type.
  List<int> _buildMdnsQuery(String name) {
    final List<int> packet = [];

    // Transaction ID (2 bytes)
    packet.addAll([0x00, 0x00]);
    // Flags: standard query (2 bytes)
    packet.addAll([0x00, 0x00]);
    // Questions: 1 (2 bytes)
    packet.addAll([0x00, 0x01]);
    // Answer RRs: 0 (2 bytes)
    packet.addAll([0x00, 0x00]);
    // Authority RRs: 0 (2 bytes)
    packet.addAll([0x00, 0x00]);
    // Additional RRs: 0 (2 bytes)
    packet.addAll([0x00, 0x00]);

    // Query name
    final labels = name.split('.');
    for (final label in labels) {
      packet.add(label.length);
      packet.addAll(label.codeUnits);
    }
    packet.add(0x00); // Null terminator

    // Type: PTR (12)
    packet.addAll([0x00, 0x0C]);
    // Class: IN (1) with unicast-response bit
    packet.addAll([0x00, 0x01]);

    return packet;
  }

  /// Attempts to parse a discovered server from an mDNS response packet.
  /// Returns null if the response doesn't contain valid server information.
  DiscoveredServer? _parseMdnsResponse(Datagram datagram) {
    final data = datagram.data;

    // Basic validation - minimum DNS header size
    if (data.length < 12) return null;

    // Check if this is a response (bit 15 of flags should be 1)
    if ((data[2] & 0x80) == 0) return null;

    // Use the sender's address as the host
    final host = datagram.address.address;
    int port = 80;
    String protocol = 'http';
    String? name;

    // Try to extract SRV record (port) and TXT record (protocol)
    // by scanning the response data
    int offset = 12;
    try {
      // Skip questions section
      final qdCount = (data[4] << 8) | data[5];
      for (int i = 0; i < qdCount && offset < data.length; i++) {
        offset = _skipName(data, offset);
        offset += 4; // Skip QTYPE and QCLASS
      }

      // Parse answer/additional sections for SRV and TXT records
      final anCount = (data[6] << 8) | data[7];
      final nsCount = (data[8] << 8) | data[9];
      final arCount = (data[10] << 8) | data[11];
      final totalRecords = anCount + nsCount + arCount;

      for (int i = 0; i < totalRecords && offset < data.length - 2; i++) {
        offset = _skipName(data, offset);
        if (offset + 10 > data.length) break;

        final type = (data[offset] << 8) | data[offset + 1];
        final rdLength = (data[offset + 8] << 8) | data[offset + 9];
        offset += 10;

        if (offset + rdLength > data.length) break;

        if (type == 33 && rdLength >= 6) {
          // SRV record
          port = (data[offset + 4] << 8) | data[offset + 5];
        } else if (type == 16) {
          // TXT record
          final txtData = String.fromCharCodes(
              data.sublist(offset, offset + rdLength));
          if (txtData.contains('protocol=https')) {
            protocol = 'https';
          } else if (txtData.contains('protocol=http')) {
            protocol = 'http';
          }
        } else if (type == 12) {
          // PTR record - might contain the service name
          try {
            name = _readName(data, offset);
          } catch (_) {}
        }

        offset += rdLength;
      }
    } catch (e) {
      _log.w('Error parsing DNS records: $e');
    }

    // Determine protocol from port if not specified in TXT
    if (port == 443) protocol = 'https';

    return DiscoveredServer(
      host: host,
      port: port,
      protocol: protocol,
      name: name,
    );
  }

  /// Skips a DNS name in the packet, handling compression pointers.
  int _skipName(List<int> data, int offset) {
    while (offset < data.length) {
      final len = data[offset];
      if (len == 0) return offset + 1;
      if ((len & 0xC0) == 0xC0) return offset + 2; // Compression pointer
      offset += len + 1;
    }
    return offset;
  }

  /// Reads a DNS name from the packet at the given offset.
  String _readName(List<int> data, int offset) {
    final parts = <String>[];
    int maxJumps = 10;
    while (offset < data.length && maxJumps > 0) {
      final len = data[offset];
      if (len == 0) break;
      if ((len & 0xC0) == 0xC0) {
        offset = ((len & 0x3F) << 8) | data[offset + 1];
        maxJumps--;
        continue;
      }
      offset++;
      if (offset + len > data.length) break;
      parts.add(String.fromCharCodes(data.sublist(offset, offset + len)));
      offset += len;
    }
    return parts.join('.');
  }
}
