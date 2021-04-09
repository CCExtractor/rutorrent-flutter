import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/Download/download_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DownloadView extends StatelessWidget {
 const DownloadView({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<DownloadViewModel>.reactive(
     builder: (context, model, child) => Scaffold(),
     viewModelBuilder: () => DownloadViewModel(),
   );
 }
}