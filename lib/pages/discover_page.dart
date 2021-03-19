import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/api/api_conf.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final BonsoirDiscovery zeroconfService =
      BonsoirDiscovery(type: "_rutorrent_mobile._tcp");
  final List<ResolvedBonsoirService> urls = [];
  StreamSubscription zeroconfSub;

  @override
  void dispose() {
    zeroconfSub?.cancel();
    if (zeroconfService.isReady && !zeroconfService.isStopped) {
      zeroconfService.stop();
    }
    super.dispose();
  }

  static buildURL(ResolvedBonsoirService resolved) {
    // TODO: Enable password authentication
    var protocol = resolved.attributes["protocol"];
    var port = resolved.port;
    if (port == 80) {
      return "http://${resolved.ip}/";
    } else if (port == 443) {
      return "https://${resolved.ip}/";
    } else {
      if (protocol != null) {
        return "$protocol://${resolved.ip}:${resolved.port}/";
      } else {
        return "http://${resolved.ip}:${resolved.port}";
      }
    }
  }

  void setupListener() {
    zeroconfSub = zeroconfService.eventStream.listen((event) {
      if (event.isServiceResolved &&
          event.type == BonsoirDiscoveryEventType.DISCOVERY_SERVICE_RESOLVED) {
        var resolved = event.service as ResolvedBonsoirService;
        setState(() {
          urls.add(resolved);
        });
      }
    });
    zeroconfService.start();
  }

  @override
  void initState() {
    zeroconfService.ready.then((_) => setupListener());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(urls[index].name),
          subtitle: Text("IP address: ${urls[index].ip}"),
          onTap: () {
            var api = Api();
            api.setUrl(buildURL(urls[index]));
            api.setUsername("");
            api.setPassword("");
            Navigator.of(context).pop(api);
          },
        ),
        itemCount: urls.length,
      )),
    );
  }
}
