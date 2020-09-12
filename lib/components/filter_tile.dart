import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            ? Theme.of(context).disabledColor
            : null,
        child: ListTile(
          dense: true,
          leading: Icon(icon,color: Provider.of<Mode>(context).isLightMode?Colors.black:Colors.white,),
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
