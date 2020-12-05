import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  final String title;
  final String optionRightText;
  final Function optionRightOnPressed;
  final String optionLeftText;
  final Function optionLeftOnPressed;

  CustomDialog({this.title,this.optionRightText,this.optionRightOnPressed,this.optionLeftText,this.optionLeftOnPressed});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title,
        style: TextStyle(fontSize: 15),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(optionLeftText,style: TextStyle(color: Theme.of(context).accentColor),),
          onPressed: optionLeftOnPressed,
        ),
        FlatButton(
          child: Text(optionRightText,style: TextStyle(color: Theme.of(context).accentColor),),
          onPressed: optionRightOnPressed,
        ),
      ],
    );
  }
}