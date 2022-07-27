import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/screens/rss_filter_edit_screen.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
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

  setRSSFilter(rssfilters) async {
    await ApiRequests.setRSSFilter(
        Provider.of<Api>(context, listen: false), rssfilters);
    await fetchRSSFilters();
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
    return Scaffold(
      body: Container(
        height: 500,
        child: isLoading
            ? LoadingShimmer().loadingEffect(context)
            : Column(
                children: <Widget>[
                  ((rssFilters?.length ?? 0) != 0)
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: rssFilters.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '${index + 1}. ${rssFilters[index].name.replaceAll("+", " ")}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            Checkbox(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              onChanged: (val) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                rssFilters[index].enabled =
                                                    rssFilters[index].enabled ==
                                                            0
                                                        ? 1
                                                        : 0;
                                                setRSSFilter(rssFilters);
                                              },
                                              value:
                                                  rssFilters[index].enabled ==
                                                      1,
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Flexible(
                                                  child: Text(rssFilters[index]
                                                      .pattern)),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Flexible(
                                                  child: Text(
                                                      rssFilters[index].label ??
                                                          "")),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Flexible(
                                                  child: Text(rssFilters[index]
                                                      .exclude)),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      rssFilters[index].dir ??
                                                          "")),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RSSFilterEditScreen(
                                                          index: index,
                                                          rssFilters:
                                                              rssFilters,
                                                          func: setRSSFilter,
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Expanded(
                          child: Center(
                          child: SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.light
                                ? 'assets/logo/empty.svg'
                                : 'assets/logo/empty_dark.svg',
                            width: 120,
                            height: 120,
                          ),
                        )),
                ],
              ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20, right: 15),
        child: FloatingActionButton(
          heroTag: "a",
          onPressed: () {
            rssFilters.add(RSSFilter());
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RSSFilterEditScreen(
                    index: rssFilters.length - 1,
                    rssFilters: rssFilters,
                    func: setRSSFilter,
                  ),
                ));
          },
          backgroundColor: kIndigoSecondaryLT,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
