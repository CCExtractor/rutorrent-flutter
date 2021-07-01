import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/loading_shimmer.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/RSS%20Label%20Tile/RSS%20Detail%20Sheet/rss_detail_sheet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RSSDetailSheetView extends StatelessWidget {
  final RSSItem rssItem;
  final String hash;
  RSSDetailSheetView(this.rssItem, this.hash);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RSSDetailSheetViewModel>.reactive(
      onModelReady: (model) => model.init(rssItem, hash),
      builder: (context, model, child) => Container(
        height: 400,
        child: Scaffold(
          body: model.isBusy
              ? LoadingShimmer().loadingEffect(context, length: 2)
              : !model.dataAvailable
                  ? Center(
                      child: Text(
                      'No Information available about this Item',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                !AppStateNotifier.isDarkModeOn
                                                    ? Colors.black
                                                    : Colors.white,
                                            width: 2)),
                                    height: 200,
                                    child: ClipRRect(
                                      child: Image.network(
                                        rssItem.imageUrl!,
                                        errorBuilder:
                                            (context, exception, stackTrace) =>
                                                Container(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              rssItem.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          IconButton(
                                            color: AppStateNotifier.isDarkModeOn
                                                ? Colors.white
                                                : Colors.black,
                                            icon: FaIcon(
                                                FontAwesomeIcons.plusSquare),
                                            onPressed: () =>
                                                model.addTorrent(rssItem.url),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        rssItem.size!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        rssItem.rating!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rssItem.runtime!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rssItem.genre!,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                rssItem.description!,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
      viewModelBuilder: () => RSSDetailSheetViewModel(),
    );
  }
}
