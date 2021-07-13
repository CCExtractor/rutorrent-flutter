import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/cutom_dialog_widget.dart';

class DeleteAccountDialog extends StatelessWidget {
  final int? length;
  final int? index;
  final Function leftFunc;
  final Function rightFunc;
  DeleteAccountDialog(
      {required this.leftFunc,
      required this.rightFunc,
      this.length,
      this.index});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Are you sure you want to delete this account?' +
          '${length == 1 ? '\n\nYou will be logged out!' : ''}',
      optionLeftText: 'No',
      optionRightText: 'Yes',
      optionLeftOnPressed: () => leftFunc(),
      optionRightOnPressed: () => rightFunc(index),
    );
  }
}
