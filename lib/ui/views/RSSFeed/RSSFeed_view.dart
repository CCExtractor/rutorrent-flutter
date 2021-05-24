import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/ui/views/RSSFeed/RSSFeed_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/RSS%20Label%20Tile/rss_label_tile_view.dart';
import 'package:stacked/stacked.dart';

class RSSFeedView extends StatelessWidget {
 const RSSFeedView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<RSSFeedViewModel>.reactive(
     builder: (context, model, child) => Scaffold(
        body: RefreshIndicator(
          color: Theme.of(context).primaryColorLight,
          onRefresh: ()async=>{},
          child:

          model.isBusy

          ? ListTile(
                  title: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )

          :
             Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'All Feeds (${model.getTotalFeeds()})',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  (model.rssLabelsList.length != 0)
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: model.rssLabelsList.length,
                            itemBuilder: (context, index) {
                              return RSSLabelTileView(rssLabel:model.rssLabelsList[index]);
                            },
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.75,
                              alignment: Alignment.center,
                              child: Center(
                                child: SvgPicture.asset(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? 'assets/logo/empty.svg'
                                      : 'assets/logo/empty_dark.svg',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
        ),
      ),
     viewModelBuilder: () => RSSFeedViewModel(),
   );
 }
}