import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import 'package:rutorrentflutter/components/search_bar.dart';
import 'package:rutorrentflutter/components/torrent_tile.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import '../components/loading_shimmer.dart';

class TorrentsListPage extends StatelessWidget {
  checkForActiveDownloads(Api api, GeneralFeatures general) async {
    /* this method is responsible for changing the connection state from waiting to active by
    temporary pausing the active downloads and then resuming them again
     */
    List<Torrent> tempPausedDownloads = [];
    for (Torrent torrent in general.activeDownloads) {
      await ApiRequests.pauseTorrent(api, torrent.hash);
      tempPausedDownloads.add(torrent);
    }

    // Resuming the temporary paused active downloads
    for (Torrent torrent in tempPausedDownloads) {
      await ApiRequests.startTorrent(api, torrent.hash);
    }
  }

  List<Torrent> _getDisplayList(List<Torrent> list, GeneralFeatures general) {
    List<Torrent> displayList = list;

    //Sorting: sorting data on basis of sortPreference
    displayList = general.sortList(displayList, general.sortPreference);

    //Filtering: filtering list on basis of selected filter
    displayList = general.filterList(displayList, general.selectedFilter);

    //If Label is selected, filtering it using the label
    if(general.isLabelSelected) {
      displayList =
          general.filterListUsingLabel(displayList, general.selectedLabel);
    }


    if (general.searchTextController.text.isNotEmpty) {
      //Searching : showing list on basis of searched text
      displayList = displayList
          .where((element) => element.name
              .toLowerCase()
              .contains(general.searchTextController.text.toLowerCase()))
          .toList();
    }
    return displayList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralFeatures>(builder: (context, general, child) {
      return Column(
        children: <Widget>[
          SearchBar(),
          Expanded(
            child: StreamBuilder(
              stream: general.allAccounts
                  ? ApiRequests.getAllAccountsTorrentList(general.apis, general)
                  : ApiRequests.getTorrentList(
                      Provider.of<Api>(context), general),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    checkForActiveDownloads(
                        Provider.of<Api>(context, listen: false),
                        Provider.of<GeneralFeatures>(context, listen: false));

                    // showing loading list of Shimmer
                    return LoadingShimmer().loadingEffect(context, length: 5);
                  }

                  if (snapshot.hasData) {
                    general.updateTorrentsList(
                        _getDisplayList(snapshot.data, general));
                  }

                  return ListView.builder(
                    itemCount: general.torrentsList.length,
                    itemBuilder: (context, index) {
                      return (snapshot.hasData &&
                              general.torrentsList.length != 0)
                          ? TorrentTile(general.torrentsList[index])
                          : Center(
                              child: Text(
                                'No Torrents to Show',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            );
                    },
                  );
                }
                return Center(
                  child: Text(
                    'No Torrents to Show',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
