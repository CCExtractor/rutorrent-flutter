import 'package:flutter/material.dart';
import 'package:rutorrentflutter/models/torrent.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/cutom_dialog_widget.dart';

class RemoveTorrentDialog extends StatelessWidget {
  final Torrent torrent;
  final Function callBackRight;
  final Function callBackLeft;
  RemoveTorrentDialog(
      {this.callBackLeft, this.callBackRight, this.torrent, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Remove Torrent',
      optionRightText: 'Remove Torrent and Delete Data',
      optionLeftText: 'Remove Torrent',
      optionRightOnPressed: () {
        callBackRight(torrent.hash);
        Navigator.pop(context);
      },
      optionLeftOnPressed: () {
        callBackLeft(torrent.hash);
        Navigator.pop(context);
      },
    );
  }
}
