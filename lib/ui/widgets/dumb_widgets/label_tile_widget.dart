import 'package:flutter/material.dart';
import 'package:rutorrentflutter/theme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Drawer/drawer_viewmodel.dart';

class LabelTile extends StatelessWidget {
  final DrawerViewModel model;
  final String label;
  LabelTile({required this.model, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (model.selectedLabel == label && model.isLabelSelected)
          ? Theme.of(context).disabledColor
          : null,
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.label_important_outline,
          color: !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white,
        ),
        title: Text(label),
        onTap: () {
          print("ontapp label");
          model.changeLabel(label);
          Navigator.pop(context);
        },
      ),
    );
  }
}
