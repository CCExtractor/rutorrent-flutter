import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
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
    return Container(
      height: 500,
      child: isLoading
          ? LoadingShimmer().loadingEffect(context)
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: rssFilters.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${index + 1}. ${rssFilters[index].name}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    Checkbox(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      onChanged: (val) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please use ruTorrent web interface to change filter settings');
                                      },
                                      value: rssFilters[index].enabled == 1,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Pattern: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Flexible(
                                          child:
                                              Text(rssFilters[index].pattern)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Label: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Flexible(
                                          child: Text(rssFilters[index].label)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Exclude: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Flexible(
                                          child:
                                              Text(rssFilters[index].exclude)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Save Directory: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Flexible(
                                          child: Text(rssFilters[index].dir)),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
