import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../api/api_conf.dart';
import '../api/api_requests.dart';
import 'data_input.dart';

class AddBottomSheet extends StatefulWidget {
  final Api api;
  final Function apiRequest;
  final String dialogHint;

  AddBottomSheet(
      {this.api, @required this.apiRequest, @required this.dialogHint});

  @override
  _AddBottomSheetState createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  final TextEditingController urlTextController = TextEditingController();

  final FocusNode urlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String torrentPath;

  File torrentFile;

  // validating url through regex
  bool isValidUrl(String input) {
    var urlRegex = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    if (RegExp(urlRegex).hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  // output a invalid error message if url is invalid
  String urlValidator(String input) {
    if (!isValidUrl(input)) {
      return 'Please enter a valid url';
    }
    return null;
  }

  void pickTorrentFile() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["torrent"]);
    if (result == null) {
      Fluttertoast.showToast(msg: 'No file selected');
    } else if (result.files.first.extension == "torrent") {
      torrentPath = result.files.first.path;
      print("path: $torrentPath");
      ApiRequests.addTorrentFile(widget.api, torrentPath);
    } else {
      Fluttertoast.showToast(msg: 'Invalid file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    double wp = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: wp * 0.35,
            ),
            height: 5,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Add link',
            style: TextStyle(
                fontSize: 14,
                color: Provider.of<Mode>(context).isLightMode
                    ? Colors.black54
                    : Colors.white),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: DataInput(
                borderColor: Provider.of<Mode>(context).isLightMode
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                textEditingController: urlTextController,
                hintText: widget.dialogHint,
                focus: urlFocus,
                validator: urlValidator,
                suffixIconButton: IconButton(
                  color: Provider.of<Mode>(context).isLightMode
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  onPressed: () async {
                    ClipboardData data = await Clipboard.getData('text/plain');
                    if (data != null)
                      urlTextController.text = data.text.toString();
                    if (urlFocus.hasFocus) urlFocus.unfocus();
                  },
                  icon: Icon(Icons.content_paste),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  primary: Theme.of(context).primaryColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Text(
                  'Start Download',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.apiRequest(urlTextController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          (widget.dialogHint == "Enter Rss Url")
              ? Container()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        primary: Theme.of(context).primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      child: Text(
                        'Browse Torrent File',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    onPressed: () {
                      pickTorrentFile();
                      Navigator.pop(context);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
