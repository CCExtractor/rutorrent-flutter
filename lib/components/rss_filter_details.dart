import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rutorrentflutter/constants.dart';

import 'loading_shimmer.dart';

class RSSFilterDetails extends StatefulWidget {
  @override
  _RSSFilterDetailsState createState() => _RSSFilterDetailsState();
}

class _RSSFilterDetailsState extends State<RSSFilterDetails> {
  bool isLoading = true;
  List<RSSFilter> rssFilters = [];

  fetchRSSFilters() async {
    rssFilters = await ApiRequests.getRSSFilters(
        Provider.of<Api>(context, listen: false));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRSSFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 500,
        child: Column(
          children: <Widget>[
            isLoading?
            Shimmer.fromColors(
                baseColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[300]
                    : kDarkGrey,
                highlightColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[100]
                    : kLightGrey,
                child: LoadingShimmer()
            ):Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text('RSS Filters', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),
                    )),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: rssFilters.length,
                        itemBuilder: (context,index){
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(rssFilters[index].name,
                                        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                                      ),
                                      Checkbox(
                                        activeColor: Colors.grey,
                                        onChanged: (val){},
                                        value: rssFilters[index].enabled==1,
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Pattern: ',style: TextStyle(fontWeight: FontWeight.w600),),
                                        Flexible(child: Text(rssFilters[index].pattern)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Label: ',style: TextStyle(fontWeight: FontWeight.w600),),
                                        Flexible(child: Text(rssFilters[index].label)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Exclude: ',style: TextStyle(fontWeight: FontWeight.w600),),
                                        Flexible(child: Text(rssFilters[index].exclude)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('Save Directory: ',style: TextStyle(fontWeight: FontWeight.w600),),
                                        Flexible(child: Text(rssFilters[index].dir)),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
