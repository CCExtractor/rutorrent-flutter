import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/loading_shimmer.dart';
import 'package:rutorrentflutter/models/rss.dart';

class RSSFeeds extends StatelessWidget {

  _getTotalFeeds(List<RSSLabel> rssLabelsList){
    int feeds = 0;
    for(var rss in rssLabelsList)
      feeds+=rss.items.length;
    return feeds;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiRequests.loadRSS(Provider.of<Api>(context)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return ListTile(
            title: Text('Loading...',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
          );
        }
        List<RSSLabel> rssLabelsList = snapshot.data ?? [];
        return Column(
          children: <Widget>[
            ListTile(
              title: Text('All Feeds (${_getTotalFeeds(rssLabelsList)})',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: rssLabelsList.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      leading: FaIcon(
                          FontAwesomeIcons.rssSquare
                      ),
                      title: Text(
                        rssLabelsList[index].label + ' (${rssLabelsList[index].items.length})',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      children: rssLabelsList[index]
                          .items
                          .map(
                            (item) => ListTile(
                              title: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
                                child: Text(
                                  item.title,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: (){
                                  ApiRequests.addTorrentUrl(Provider.of<Api>(context),item.url);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
