import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';

class LabelTile extends StatelessWidget {
  final String label;

  LabelTile({this.label});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralFeatures>(builder: (context, general, child) {
      return Container(
        color: (general.selectedLabel == label && general.isLabelSelected)
            ? Theme.of(context).disabledColor
            : null,
        child: ListTile(
          dense: true,
          leading: Icon(
            Icons.label_important_outline,
            color: Provider.of<Mode>(context).isLightMode
                ? Colors.black
                : Colors.white,
          ),
          title: Text(
              label),
          onTap: () {
            print("ontapp label");
            general.changeLabel(label);
            Navigator.pop(context);
          },
        ),
      );
    });
  }
}
