import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';
import '../utilities/constants.dart';
import 'package:flutter/material.dart';

class AddDialog extends StatelessWidget {

  final Function apiRequest;
  final String dialogHint;
  final TextEditingController urlTextController = TextEditingController();

  AddDialog({this.apiRequest,this.dialogHint});

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
        height: 120,
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 70,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      controller: urlTextController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                          hintText: dialogHint??'Enter url here'),
                    ),
                  ),
                  IconButton(
                    onPressed: () async{
                      ClipboardData data = await Clipboard.getData('text/plain');
                      urlTextController.text = data.text.toString();
                    },
                    icon: Icon(Icons.content_paste),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                color: Provider.of<Mode>(context).isLightMode ? kBlue : kIndigo,
                child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 16),),
                onPressed: () {
                  Navigator.pop(context);
                  apiRequest(urlTextController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
