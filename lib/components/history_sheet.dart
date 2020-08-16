import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_shimmer.dart';

class HistorySheet extends StatefulWidget {
  @override
  _HistorySheetState createState() => _HistorySheetState();
}

class _HistorySheetState extends State<HistorySheet> {
  List<HistoryItem> items = [];
  bool isLoading;

  loadHistoryItems({int lastHrs}) async {
    setState(() {
      isLoading=true;
    });
    items = await ApiRequests.getHistory(
        Provider.of<Api>(context, listen: false),
        lastHours: lastHrs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHistoryItems();
  }

  Color getHistoryStatusColor(BuildContext context, int action) {
    switch (action) {
      case 1:
        return Provider.of<Mode>(context).isLightMode ? kBlue : kIndigo;
      case 2:
        return Provider.of<Mode>(context).isLightMode ? kGreen : kLightGreen;
      case 3:
        return kRed;
      default:
        return Provider.of<Mode>(context).isLightMode
            ? Colors.black
            : Colors.white;
    }
  }

  List<String> choices = [
    'Show Last 24 Hours',
    'Show Last 36 Hours',
    'Show Last 48 Hours'
  ];

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<String>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.filter_list),
                ),
                itemBuilder: (context) {
                  return choices
                      .map((e) => PopupMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList();
                },
                onSelected: (e) {
                  loadHistoryItems(lastHrs: int.parse(e.split(' ')[2]));
                },
              )
            ],
          ),
        ),
        Divider(),
        isLoading
            ? Shimmer.fromColors(
                baseColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[300]
                    : kDarkGrey,
                highlightColor: Provider.of<Mode>(context).isLightMode
                    ? Colors.grey[100]
                    : kLightGrey,
                child: LoadingShimmer())
            : Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: SizedBox(
                            width: 40,
                            child: Text(items[index].name,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))),
                        trailing: Container(
                          padding: const EdgeInsets.all(4),
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: getHistoryStatusColor(
                                context, items[index].action),)
                          ),
                          child: Text(
                              HistoryItem.historyStatus[items[index].action],
                              style: TextStyle(
                                color: getHistoryStatusColor(
                                    context, items[index].action),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        leading: Text(
                          '${DateFormat('dd.MM.yyyy\nHH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(items[index].actionTime * 1000))}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      );
                    }),
              ),
      ],
    );
  }
}
