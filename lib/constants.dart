import 'package:flutter/material.dart';

import 'models/task.dart';

/// This file contains constants which can be used in any part of the project
class  Constants{
  Map<Status,String> statusMap = {
    Status.downloading : 'start',
    Status.pausing : 'pause',
    Status.stopped: 'stop',
  };

  Color kBlue = Color(0xFF1B1464);
  Color kRed = Color(0xFFEA2027);
  Color kGreen = Color(0xFF009432);
  Color kLightGrey = Color(0xFFF7F7F7);
  Color kDarkGrey = Color(0xFF424342);
}