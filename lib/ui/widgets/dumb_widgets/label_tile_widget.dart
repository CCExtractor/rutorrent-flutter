import 'package:flutter/material.dart';

import 'package:rutorrentflutter/app/constants.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Drawer/drawer_viewmodel.dart';

class LabelTile extends StatelessWidget {
  final DrawerViewModel model;
  final String label;
  final Widget? icon;
  LabelTile({
    required this.model,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = model.selectedLabel == label && model.isLabelSelected;

    return Container(
      color: isSelected ? Theme.of(context).colorScheme.secondary : null,
      child: ListTile(
        dense: true,
        leading: DefaultLabelsEnum.values
                .map((element) => element.name)
                .toList()
                .contains(label.replaceAll('_', '').replaceAll(' ', ''))
            ? Image.asset(
                '${DefaultPaths.defaultLabelIcons}${label.toLowerCase()}.png',
                alignment: Alignment.centerLeft,
                width: IconTheme.of(context).size,
              )
            : Icon(
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
