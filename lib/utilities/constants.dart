/// This dart library contains constants which can be used in any part of the project

library constants;

import 'package:flutter/material.dart';

/// Colors for light theme
const Color kGreyLT = Color(0xFFCDCDCD);
const Color kBluePrimaryLT = Color(0xFF1B1464);
const Color kIndigoSecondaryLT = Color(0xFF3D3EE6);
const Color kRedErrorLT = Color(0xFFEA2027);
const Color kGreenActiveLT = Color(0xFF009432);

/// Colors for dark theme
const Color kGreyDT = Color(0xFF2E2E2E);
const Color kPrimaryDT = Color(0xFF613EEA);
const Color kSecondaryDT = Color(0xFF987BEE);
const Color kRedErrorDT = Color(0xFFEF5350);
const Color kGreenActiveDT = Color(0xFF1ED760);
const Color kBackgroundDT = Color(0xFF121212);

///Notification Channel Names and Descriptions
///
///[Key] : Enum index of corresponding notification channel ID
///
///[Value] : List
///        First element being Notification Channel Name,
///        Second element being Notification Channel Description
Map<int, List<String>> notificationInfo = {
  0: [
    'Torrent Added Channel',
    'This Channel is for notifying when a new Torrent is added'
  ],
  1: [
    'Download Completed Channel',
    'This Channel is for notifying when a download is completed'
  ],
  2: [
    'Low Disk Space Channel',
    'This Channel is for notifying when there is Low Disk Space'
  ],
};

/// APP RELEASE INFO
const buildNumber = '2';
const releaseDate = '28.02.20';
