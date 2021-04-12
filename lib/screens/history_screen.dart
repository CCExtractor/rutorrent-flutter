import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/models/history_item.dart';
import 'package:rutorrentflutter/utilities/constants.dart';
import 'package:rutorrentflutter/models/mode.dart';
import '../components/loading_shimmer.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> items = [];
  bool isLoading;

  loadHistoryItems({int lastHrs}) async {
    setState(() {
      isLoading = true;
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
      case 1: // Added
        return Theme.of(context).accentColor;
      case 2: // Finished
        return Provider.of<Mode>(context).isLightMode
            ? kGreenActiveLT
            : kGreenActiveDT;
      case 3: // Deleted
        return Provider.of<Mode>(context).isLightMode
            ? kRedErrorLT
            : kRedErrorDT;
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

  _showRemoveDialog(String hashValue) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Remove torrent from history',
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Yes!',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    ApiRequests.removeHistoryItem(
                        Provider.of<Api>(context, listen: false), hashValue);
                    loadHistoryItems();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.filter_list),
            ),
            itemBuilder: (context) {
              return choices
                  .map((e) => PopupMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ))
                  .toList();
            },
            onSelected: (e) {
              loadHistoryItems(lastHrs: int.parse(e.split(' ')[2]));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: isLoading
            ? LoadingShimmer().loadingEffect(context)
            : (items.length != 0)
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onLongPress: () {
                          _showRemoveDialog(items[index].hash);
                        },
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
                              border: Border.all(
                            color: getHistoryStatusColor(
                                context, items[index].action),
                          )),
                          child: Text(
                              HistoryItem.historyStatus[items[index].action],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: getHistoryStatusColor(
                                    context, items[index].action),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        subtitle: Text(
                          '${DateFormat('HH:mm dd MMM yy').format(DateTime.fromMillisecondsSinceEpoch(items[index].actionTime * 1000))} | ${filesize(items[index].size)}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  )
                : Center(
                    child: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? 'assets/logo/empty.svg'
                          : 'assets/logo/empty_dark.svg',
                      width: 120,
                      height: 120,
                    ),
                  ),
      ),
    );
  }
}
