import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/mode.dart';
import 'package:shimmer/shimmer.dart';

import 'loading_shimmer.dart';

class HistorySheet extends StatefulWidget {
  @override
  _HistorySheetState createState() => _HistorySheetState();
}

class _HistorySheetState extends State<HistorySheet> {
  List<HistoryItem> items = [];
  bool isLoading = true;

  loadHistoryItems() async{
    items = await ApiRequests.getHistory(Provider.of<Api>(context,listen: false));
    setState(() {
      isLoading=false;
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
        return Provider.of<Mode>(context).isLightMode ? Constants.kBlue : Constants.kIndigo;
      case 2:
        return Provider.of<Mode>(context).isLightMode ? Constants.kGreen : Constants.kLightGreen;
      case 3:
        return Constants.kRed;
      default:
        return Provider.of<Mode>(context).isLightMode
            ? Colors.black
            : Colors.white;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Divider(),
          isLoading
              ? Shimmer.fromColors(
            baseColor: Provider.of<Mode>(context).isLightMode
                ? Colors.grey[300]
                : Constants.kDarkGrey,
            highlightColor: Provider.of<Mode>(context).isLightMode
                ? Colors.grey[100]
                : Constants.kLightGrey,
            child: LoadingShimmer()
          ):
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: SizedBox(
                        width: 40,
                        child: Text(
                            items[index].name.substring(
                                0,
                                items[index].name.contains('[')
                                    ? items[index].name.indexOf('[')
                                    : items[index].name.length),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600))),
                    leading: SizedBox(
                      width: 80,
                      child:
                          Text(HistoryItem.historyStatus[items[index].action],
                              style: TextStyle(
                                color: getHistoryStatusColor(
                                    context, items[index].action),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                    ),
                    trailing: Text(
                      '${DateFormat('dd.MM.yyyy\nHH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(items[index].actionTime * 1000))}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
