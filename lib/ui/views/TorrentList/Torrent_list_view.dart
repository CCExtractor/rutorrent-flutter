import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/ui/views/TorrentList/Torrent_list_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/loading_shimmer.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/no_torrent_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Search%20Bar/search_bar_view.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Torrent%20Tile/torrent_tile_view.dart';
import 'package:stacked/stacked.dart';

final log = getLogger("TorrentListView");

class TorrentListView extends StatefulWidget  {
  const TorrentListView({Key? key}) : super(key: key);

  @override
  _TorrentListViewState createState() => _TorrentListViewState();
}

class _TorrentListViewState extends State<TorrentListView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<TorrentListViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: <Widget>[
          SearchBarWidget(),
          Expanded(
            child: StreamBuilder(
              stream: model.showAllAccounts
                  ? model.getAllAccountsTorrentList()
                  : model.getTorrentList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                bool waitingState =
                    snapshot.connectionState == ConnectionState.waiting;

                // Condition for loading state
                if (waitingState && !snapshot.hasData) {
                  model.checkForActiveDownloads();

                  // showing loading list of Shimmer
                  return LoadingShimmer().loadingEffect(context, length: 5);
                }

                
                // Condition for No Data
                if (snapshot.data == null) {
                  return NoTorrentWidget();
                }


                // Updating torrent list
                if (snapshot.hasData) {
                  model.updateTorrentsList();
                }

                //Displaying List
                return ValueListenableBuilder(
                    valueListenable: model.displayTorrentList,
                    builder: (context, List<Torrent> torrents, child) {
                      // log.i("Value Notifier result " + torrents.toString());
                      return ListView.builder(
                        itemCount: torrents.length,
                        itemBuilder: (context, index) {
                          return (snapshot.hasData && torrents.length != 0)
                              ? TorrentTileView(torrents[index])
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? 'assets/logo/empty.svg'
                                            : 'assets/logo/empty_dark.svg',
                                        width: 120,
                                        height: 120,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'No Torrents to Show',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      );
                    });
              },
            ),
          ),
        ],
      ),
      viewModelBuilder: () => TorrentListViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
