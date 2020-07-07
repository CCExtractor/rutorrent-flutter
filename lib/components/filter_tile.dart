import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';

class FilterTile extends StatelessWidget {
  final Filter filter;
  final IconData icon;

  FilterTile({this.filter, this.icon});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralFeatures>(builder: (context, general, child) {
      return Container(
        color: general.selectedFilter == filter
            ? (Provider.of<Mode>(context).isDarkMode
                ? Constants.kDarkGrey
                : Constants.kLightGrey)
            : null,
        child: ListTile(
          leading: Icon(icon),
          title: Text(
              filter.toString().substring(filter.toString().indexOf('.') + 1)),
          onTap: () {
            general.changeFilter(filter);
            Navigator.pop(context);
          },
        ),
      );
    });
  }
}
