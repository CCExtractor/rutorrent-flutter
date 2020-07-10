import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;

class RSSLabelTile extends StatefulWidget {
  final RSSLabel rssItem;
  final Function refreshCallback;
  RSSLabelTile(this.rssItem,this.refreshCallback);

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
          color: isLongPressed
              ? (Provider.of<Mode>(context).isLightMode
                  ? Constants.kLightGrey
                  : Constants.kDarkGrey)
              : null,
          child: isLongPressed
              ? ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  leading: FaIcon(FontAwesomeIcons.rssSquare),
                  title: Text(
                    widget.rssItem.label + ' (${widget.rssItem.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async{
                        Fluttertoast.showToast(msg: 'Removing');
                        await ApiRequests.removeRSS(api, widget.rssItem.hash);
                        widget.refreshCallback();
                      }),
                )
              : ExpansionTile(
                  leading: FaIcon(FontAwesomeIcons.rssSquare),
                  title: Text(
                    widget.rssItem.label + ' (${widget.rssItem.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  children: widget.rssItem.items
                      .map(
                        (item) => ListTile(
                          title: Text(
                            item.title,
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),style: TextStyle(fontSize: 10),),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              ApiRequests.addTorrent(api, item.url);
                            },
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
