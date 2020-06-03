import 'package:rutorrentflutter/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
