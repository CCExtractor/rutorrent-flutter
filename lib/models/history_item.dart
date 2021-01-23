import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryItem {
  static const Map<int, String> historyStatus = {
    1: 'Added',
    2: 'Finished',
    3: 'Deleted',
  };

  static Map<int, IconData> historyIcon = {
    1: Icons.move_to_inbox,
    2: Icons.check_box,
    3: FontAwesomeIcons.download,
  };

  String name;
  int action;
  int actionTime;
  int size;

  HistoryItem(this.name, this.action, this.actionTime, this.size);
}
