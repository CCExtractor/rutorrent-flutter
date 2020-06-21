import 'package:flutter/material.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;

class FilterTile extends StatelessWidget {
  final Function onSelection;
  final String title;
  final Constants.Filter filter;
  final bool isSelected;
  final IconData icon;

  FilterTile({this.title,this.isSelected,this.onSelection,this.filter,this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected?Constants.kLightGrey:Colors.white,
      child: ListTile(
        trailing: Icon(icon),
        title: Text(
            filter.toString().substring(filter.toString().indexOf('.')+1)),
        onTap: (){
          onSelection();
          Navigator.pop(context);
        },
      ),
    )
    ;
  }
}
