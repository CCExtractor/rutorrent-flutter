import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/TorrentList/Torrent_list_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TorrentListView extends StatelessWidget {
 const TorrentListView({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<TorrentListViewModel>.reactive(
     builder: (context, model, child) => Scaffold(),
     viewModelBuilder: () => TorrentListViewModel(),
   );
 }
}