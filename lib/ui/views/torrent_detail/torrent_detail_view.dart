import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/ui/views/torrent_detail/torrent_detail_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/cutom_dialog_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/file_tile/file_tile_widget.dart';
import 'package:stacked/stacked.dart';

class TorrentDetailView extends StatelessWidget {
  final Torrent torrent;
  TorrentDetailView({required this.torrent});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TorrentDetailViewModel>.reactive(
      onModelReady: (model) => model.init(torrent),
      builder: (context, model, child) => Scaffold(
        body: !model.isInitialised || model.isBusy
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 430,
                          color: Colors.black,
                          child:

                              /// Torrent Downloading Stack
                              Stack(
                            children: <Widget>[
                              Image(
                                width: double.infinity,
                                height: 500,
                                image: AssetImage('assets/logo/sample.png'),
                                fit: BoxFit.fill,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(Icons.keyboard_backspace,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Text(
                                        (model.torrent != null)
                                            ? model.torrent.name
                                            : "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              (model.torrent != null)
                                                  ? model.torrent
                                                              .percentageDownload <
                                                          100
                                                      ? '${filesize(model.torrent.size - model.torrent.downloadedData)} left of ${filesize(model.torrent.size)}'
                                                      : 'Size: ${filesize(model.torrent.size)}'
                                                  : "",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                          Text(
                                              (model.torrent != null)
                                                  ? '${model.torrent.percentageDownload}%'
                                                  : '',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                              color: Colors.black,
                                              iconSize: 20,
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CustomDialog(
                                                          title:
                                                              'Remove Torrent',
                                                          optionRightText:
                                                              'Remove Torrent and Delete Data',
                                                          optionLeftText:
                                                              'Remove Torrent',
                                                          optionRightOnPressed:
                                                              () {
                                                            model
                                                                .removeTorrentWithData();
                                                          },
                                                          optionLeftOnPressed:
                                                              () {
                                                            model
                                                                .removeTorrent();
                                                          },
                                                        ));
                                              }),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                              color: Colors.black,
                                              iconSize: 40,
                                              icon: Icon(model.torrent.isOpen ==
                                                      0
                                                  ? Icons.play_arrow
                                                  : model.torrent.getState == 0
                                                      ? (Icons.play_arrow)
                                                      : Icons.pause),
                                              onPressed: () => model
                                                  .toggleTorrentCurrentStatus()),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            color: Colors.black,
                                            iconSize: 25,
                                            icon: Icon(Icons.stop),
                                            onPressed: () => model.stopTorrent()
                                            // ApiRequests.stopTorrent(
                                            //     model.torrent.api, model.torrent.hash)
                                            ,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                              color: Colors.black,
                                              iconSize: 25,
                                              icon: Icon(Icons
                                                  .label_important_outline),
                                              onPressed: () => model
                                                  .showLabelDialog(context)),
                                        )
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 16),
                                      child: LinearProgressIndicator(
                                        value: (model.torrent != null)
                                            ? model.torrent.percentageDownload /
                                                100
                                            : 100,
                                        backgroundColor: Colors.grey,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      ExpansionTile(
                        initiallyExpanded: model.torrent != null &&
                            model.torrent.status == Status.downloading,
                        title: Text(
                          'More Info',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Seed',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'ETA : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                model.torrent != null &&
                                                        model.torrent.dlSpeed >
                                                            0
                                                    ? model.torrent.eta
                                                    : '∞',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Seeds : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                (model.torrent != null)
                                                    ? '${model.torrent.seedsActual}'
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Ratio : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                model.torrent != null
                                                    ? '${model.torrent.ratio / 1000}'
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Peer : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                model.torrent != null
                                                    ? '${model.torrent.peersActual}'
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Data',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )),
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Downloaded : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            model.torrent != null
                                                ? '${filesize(model.torrent.downloadedData)}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text('Uploaded : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                            model.torrent != null
                                                ? '${filesize(model.torrent.uploadedData)}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Speed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )),
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Download : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            model.torrent != null
                                                ? '${filesize(model.torrent.dlSpeed)}/s'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Upload : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            model.torrent != null
                                                ? '${filesize(model.torrent.ulSpeed)}/s'
                                                : '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Save Path',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        model.torrent != null
                                            ? '${model.torrent.savePath}'
                                            : '',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Files',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        children: <Widget>[
                          ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: model.files.length,
                            itemBuilder: (context, index) {
                              return FileTileWidget(model.files[index],
                                  model.torrent, model.syncFiles);
                            },
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          'Trackers',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        children: <Widget>[
                          ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: model.trackers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                title: Text(
                                  model.trackers[index],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
      viewModelBuilder: () => TorrentDetailViewModel(),
    );
  }

  // IconData getTorrentIconData(Torrent torrent) {
  //   return
  // }
}
