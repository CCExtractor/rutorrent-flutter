import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Drawer/drawer_viewmodel.dart';

class FilterTile extends StatelessWidget {
  final DrawerViewModel model;
  final Filter filter;
  final IconData icon;
  final int count;

  FilterTile(
      {required this.model,
      required this.filter,
      required this.icon,
      required this.count});

  @override
  Widget build(BuildContext context) {
    bool isSelected =
        (model.selectedFilter == filter && !model.isLabelSelected);
    return Container(
      color: isSelected ? Theme.of(context).colorScheme.secondary : null,
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : !AppStateNotifier.isDarkModeOn
                  ? Colors.black
                  : Colors.white,
        ),
        trailing: Text(
          '( $count )',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : !AppStateNotifier.isDarkModeOn
                    ? Colors.black
                    : Colors.white,
          ),
        ),
        title: Text(
          filter.toString().substring(filter.toString().indexOf('.') + 1),
          style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : !AppStateNotifier.isDarkModeOn
                      ? Colors.black
                      : Colors.white),
        ),
        onTap: () {
          model.changeFilter(filter);
          Navigator.pop(context);
        },
      ),
    );
  }
}

List filterTileIcons = [
  Icons.filter_tilt_shift,
  FontAwesomeIcons.arrowAltCircleDown,
  Icons.done_outline,
  Icons.open_with,
  Icons.not_interested,
  Icons.error,
];

// List<FilterTile> filterTileList = [
//     FilterTile(
//       icon: Icons.filter_tilt_shift,
//       filter: Filter.All,
//     ),
//     FilterTile(
//       icon: FontAwesomeIcons.arrowAltCircleDown,
//       filter: Filter.Downloading,
//     ),
//     FilterTile(
//       icon: Icons.done_outline,
//       filter: Filter.Completed,
//     ),
//     FilterTile(
//       icon: Icons.open_with,
//       filter: Filter.Active,
//     ),
//     FilterTile(
//       icon: Icons.not_interested,
//       filter: Filter.Inactive,
//     ),
//     FilterTile(
//       icon: Icons.error,
//       filter: Filter.Error,
//     ),
//   ];
