import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/RSSFeed/RSSFeed_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RSSFeedView extends StatelessWidget {
 const RSSFeedView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<RSSFeedViewModel>.reactive(
     builder: (context, model, child) => Scaffold(),
     viewModelBuilder: () => RSSFeedViewModel(),
   );
 }
}