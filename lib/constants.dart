/// This dart library contains constants which can be used in any part of the project

library constants;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/task.dart';

Map<Status,String> statusMap = {
  Status.downloading : 'start',
  Status.paused : 'pause',
  Status.stopped: 'stop',
};

Color kBlue = Color(0xFF1B1464);
Color kRed = Color(0xFFEA2027);
Color kGreen = Color(0xFF009432);
Color kLightGrey = Color(0xFFC6C7C6);
Color kWhitishGrey = Color(0xFFF7F7F7);
Color kDarkGrey = Color(0xFF424342);

String getBasicAuth(){
  String username = 'username';
  String password = '*****';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  return basicAuth;
}