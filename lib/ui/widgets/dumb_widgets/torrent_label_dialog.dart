import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/models/torrent.dart';

class TorrentLabelDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController labelController;
  final Torrent torrent;
  final Function setLabelFunc;
  final Function removeLabelFunc;
  TorrentLabelDialog
  ({
      required this.formKey,
      required this.labelController,
      required this.torrent,
      required this.setLabelFunc,
      required this.removeLabelFunc
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: labelController,
          validator: (_) {
            if (labelController.text.trim() != "") {
              return null;
            }
            return "Enter a valid label";
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            hintText: "Label",
          ),
        ),
      ),
      actions: [
        _actionButton(
            context,
            text: "Set Label",
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // TODO Pass this function
                setLabelFunc();
                // await ApiRequests.setTorrentLabel(torrent.api, torrent.hash,
                //     label: _labelController.text);
                // Provider.of<GeneralFeatures>(context, listen: false)
                //     .changeLabel(_labelController
                //         .text); // Doing this to ensure the filter is set to the label added
                // Navigator.pop(context);
                // Navigator.pop(context);
                Fluttertoast.showToast(msg: "Label set");
              }
            }),
        torrent.label!.isNotEmpty
            ? _actionButton(
                context,
                text: "Remove Label",
                onPressed: () async {
                  // TODO Pass this function
                  // await ApiRequests.removeTorrentLabel(
                  //   torrent.api,
                  //   torrent.hash,
                  // );
                  labelController.text = "";
                  removeLabelFunc();
                  // Provider.of<GeneralFeatures>(context, listen: false)
                  //     .changeFilter(Filter
                  //         .All); // Doing this to ensure that a empty torrent list page is not shown to the user
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Label removed");
                },
              )
            : Container(),
      ],
    );
  }

  /// Action Button for set and remove label dialog
  Widget _actionButton(BuildContext context,{required String text,required onPressed}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          primary: Theme.of(context).primaryColor,
        ),
        child: Text(
          text,
        ),
        onPressed: onPressed
        );
  }

}


