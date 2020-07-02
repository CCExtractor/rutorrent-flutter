/// This dart library contains constants which can be used in any part of the project

library constants;

import 'package:flutter/material.dart';
import 'models/general_features.dart';

const Color kBlue = Color(0xFF1B1464);
const Color kRed = Color(0xFFEA2027);
const Color kGreen = Color(0xFF009432);
const Color kLightGrey = Color(0xFFC6C7C6);
const Color kWhitishGrey = Color(0xFFF7F7F7);
const Color kDarkGrey = Color(0xFF424342);

const Map<Sort,String> sortMap = {
  Sort.name: 'Name',
  Sort.dateAdded: 'Date Added',
  Sort.percentDownloaded: 'Percent Downloaded',
  Sort.downloadSpeed: 'Download Speed',
  Sort.uploadSpeed: 'Upload Speed',
  Sort.ratio: 'Ratio',
  Sort.size: 'Size',
};

