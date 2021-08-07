import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AddAnotherAccountWidget({required Function onTap}) {
    return Container(
      child: ListTile(
        dense: true,
        leading: Icon(Icons.add),
        title: Text('Add another account'),
        onTap: () => onTap(),
      ),
    );
  }