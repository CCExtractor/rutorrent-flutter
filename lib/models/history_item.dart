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

  late String name;
  late int action;
  late int actionTime;
  int? size;
  late String hash;

  HistoryItem(this.name, this.action, this.actionTime, this.size, this.hash);

  HistoryItem.fromJSON(Map data) {
    this.name = data['name'];
    this.action = data['action'];
    this.actionTime = data['action_time'];
    this.hash = data['hash'];
  }
}
