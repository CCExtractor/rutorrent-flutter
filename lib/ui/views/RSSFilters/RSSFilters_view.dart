import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/RSSFilters/RSSFilters_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RSSFiltersView extends StatelessWidget {
 const RSSFiltersView({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<RSSFiltersViewModel>.reactive(
     builder: (context, model, child) => Scaffold(),
     viewModelBuilder: () => RSSFiltersViewModel(),
   );
 }
}