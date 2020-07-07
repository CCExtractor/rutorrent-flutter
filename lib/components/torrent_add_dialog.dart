import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/api/api_requests.dart';
import '../api/api_conf.dart';
import '../constants.dart' as Constants;
import 'package:flutter/material.dart';

class TorrentAddDialog extends StatelessWidget {

  final Api api;
  final TextEditingController urlTextController = TextEditingController();

  TorrentAddDialog(this.api);

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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    hintText: 'Paste Magnet Url Here'),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Constants.kBlue,
                  child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 16),),
                  onPressed: () {
                    Navigator.pop(context);
                    ApiRequests.addTorrentUrl(api,urlTextController.text);
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
