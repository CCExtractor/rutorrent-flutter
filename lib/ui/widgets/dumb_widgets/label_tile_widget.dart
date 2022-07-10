import 'package:flutter/material.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Drawer/drawer_viewmodel.dart';

class LabelTile extends StatelessWidget {
  final DrawerViewModel model;
  final String label;
  LabelTile({required this.model, required this.label});

  @override
  Widget build(BuildContext context) {
    bool isSelected = model.selectedLabel == label && model.isLabelSelected;
    return Container(
      color: isSelected ? Theme.of(context).colorScheme.secondary : null,
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.label_important_outline,
          color: isSelected
              ? Colors.white
              : !AppStateNotifier.isDarkModeOn
                  ? Colors.black
                  : Colors.white,
        ),
        title: Text(
          label,
          style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white),
        ),
        onTap: () {
          model.changeLabel(label);
          Navigator.pop(context);
        },
      ),
    );
  }
}
