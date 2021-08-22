import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/rss_label_tile/rss_detail_sheet/rss_detail_sheet_view.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/rss_label_tile/rss_label_tile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RSSLabelTileView extends StatelessWidget {
  final RSSLabel? rssLabel;
  RSSLabelTileView({this.rssLabel});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RSSLabelTileViewModel>.reactive(
      builder: (context, model, child) => GestureDetector(
        onLongPress: () {
          model.isLongPressed = !model.isLongPressed;
        },
        onTap: () {
          model.isLongPressed = false;
        },
        child: Container(
          color: model.isLongPressed ? Theme.of(context).disabledColor : null,
          child: model.isLongPressed
              ? ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  leading: FaIcon(FontAwesomeIcons.rssSquare),
                  title: Text(
                    (rssLabel?.label ?? "") + ' (${rssLabel?.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                      ),
                      onPressed: () async {
                        model.removeRSS(rssLabel!);
                      }),
                )
              : ExpansionTile(
                  textColor: Theme.of(context).accentColor,
                  leading: FaIcon(
                    FontAwesomeIcons.rssSquare,
                    color: Colors.orange[500],
                  ),
                  title: Text(
                    (rssLabel?.label ?? "") + ' (${rssLabel?.items.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  children: (rssLabel?.items ?? [])
                      .map(
                        (item) => ListTile(
                          onTap: () {
                            // Bottom Sheet Here
                            showBarModalBottomSheet(
                                expand: false,
                                context: context,
                                builder: (context) {
                                  return RSSDetailSheetView(
                                      item, (rssLabel?.hash ?? ""));
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
                            onPressed: () => model.addTorrent(item.url),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
      viewModelBuilder: () => RSSLabelTileViewModel(),
    );
  }
}
