import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/rss.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_shimmer.dart';

class RSSDescSheet extends StatefulWidget {
  final RSSItem rssItem;
  final String labelHash;
  final Api api;

  RSSDescSheet(this.rssItem, this.labelHash, this.api);

  @override
  _RSSDescSheetState createState() => _RSSDescSheetState();
}

class _RSSDescSheetState extends State<RSSDescSheet> {
  RSSItem rssItem;
  bool isFetching = true;
  bool dataAvailable;

  fetchRSSDetails() async {
    dataAvailable =
        await ApiRequests.getRSSDetails(widget.api, rssItem, widget.labelHash);
    setState(() {
      isFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    rssItem = widget.rssItem;
    fetchRSSDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Scaffold(
        body: isFetching
            ? Shimmer.fromColors(
                baseColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[300]
                    : Constants.kDarkGrey,
                highlightColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[100]
                    : Constants.kLightGrey,
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return LoadingShimmer();
                    }),
              )
            : !dataAvailable
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
                                          color: Provider.of<Mode>(context)
                                                  .isLightMode
                                              ? Colors.black
                                              : Colors.white,
                                          width: 5)),
                                  height: 200,
                                  child: ClipRRect(
                                    child: Image.network(
                                        rssItem.imageUrl,
                                      errorBuilder: (context,exception,stackTrace)=>Container(),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            rssItem.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                        IconButton(
                                          color: Provider.of<Mode>(context).isDarkMode?Colors.white:Colors.black,
                                          icon: FaIcon(FontAwesomeIcons.plusSquare),
                                          onPressed: ()=>ApiRequests.addTorrent(widget.api, rssItem.url),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      rssItem.size,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      rssItem.rating,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      rssItem.runtime,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      rssItem.genre,
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
                              rssItem.description,
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
