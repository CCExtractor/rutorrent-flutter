import 'package:flutter/material.dart';

class DownloadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListTile(
          title: Text('Downloads (0)',style: TextStyle(fontWeight: FontWeight.w600),),
        )
      ),
    );
  }
}
