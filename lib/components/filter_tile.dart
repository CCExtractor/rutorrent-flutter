import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/general_features.dart';

class FilterTile extends StatelessWidget {
  final Filter filter;
  final IconData icon;

  FilterTile({this.filter,this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<GeneralFeatures>(context).selectedFilter==filter?Constants.kLightGrey:Colors.white,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
            filter.toString().substring(filter.toString().indexOf('.')+1)),
        onTap: (){
          Provider.of<GeneralFeatures>(context,listen: false).changeFilter(filter);
          Navigator.pop(context);
        },
      ),
    );
  }
}
