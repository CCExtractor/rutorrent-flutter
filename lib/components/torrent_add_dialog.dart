import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TorrentAddDialog extends StatefulWidget {

  @override
  _TorrentAddDialogState createState() => _TorrentAddDialogState();
}

class _TorrentAddDialogState extends State<TorrentAddDialog> {
  final TextEditingController urlTextController = TextEditingController();

  _addTorrentUrl(String url) async {
    var response = await http.post(Uri.parse('https://fremicro081.xirvik.com/rtorrent/php/addtorrent.php'),
        headers: {
          'authorization':Constants.getBasicAuth(),
        },
        body: {
          'url': urlTextController.text,
        });
    print('body'+response.body);
    print(response.statusCode);
    print(response.hashCode);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
    ),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: TextFormField(
                style: TextStyle(fontSize: 16,color: Constants.kDarkGrey),
                controller: urlTextController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    hintText: 'Enter Url'),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Constants.kBlue,
                  child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 16),),
                  onPressed: () async{
                    Fluttertoast.showToast(msg: 'Adding torrent');
                    Navigator.pop(context);
                    _addTorrentUrl(urlTextController.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
