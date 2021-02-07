import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/rss_desc_sheet.dart';
import 'package:rutorrentflutter/models/rss.dart';

class RSSLabelTile extends StatefulWidget {
  final RSSLabel rssLabel;

  final Function refreshCallback;

  RSSLabelTile(this.rssLabel, this.refreshCallback);

  @override
  _RSSLabelTileState createState() => _RSSLabelTileState();
}

class _RSSLabelTileState extends State<RSSLabelTile> {
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Api>(builder: (context, api, child) {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            isLongPressed = !isLongPressed;
          });
        },
        onTap: () {
          setState(() {
            isLongPressed = false;
          });
        },
        child: Container(
          color: isLongPressed ? Theme.of(context).disabledColor : null,
          child: isLongPressed
              ? ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  leading: FaIcon(FontAwesomeIcons.rssSquare),
                  title: Text(
                    widget.rssLabel.label +
                        ' (${widget.rssLabel.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                      ),
                      onPressed: () async {
                        Fluttertoast.showToast(msg: 'Removing');
                        await ApiRequests.removeRSS(api, widget.rssLabel.hash);
                        widget.refreshCallback();
                      }),
                )
              : ExpansionTile(
                  leading: FaIcon(
                    FontAwesomeIcons.rssSquare,
                    color: Colors.orange[500],
                  ),
                  title: Text(
                    widget.rssLabel.label +
                        ' (${widget.rssLabel.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  children: widget.rssLabel.items
                      .map(
                        (item) => ListTile(
                          onTap: () {
                            // Bottom Sheet Here
                            showBarModalBottomSheet(
                                expand: false,
                                context: context,
                                builder: (context, scrollController) {
                                  return RSSDescSheet(
                                      item, widget.rssLabel.hash);
                                });
                          },
                          title: Text(
                            item.title,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              DateFormat('dd MMM yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      item.time * 1000)),
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                ApiRequests.addTorrent(api, item.url),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    });
  }
}
