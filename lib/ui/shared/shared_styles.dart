/// This dart library contains constants which can be used in the UI of the project
library ui_constants;

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

TextStyle kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

BoxDecoration defaultDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(width: 0.3, color: Colors.black26),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 0),
      color: Colors.black,
      spreadRadius: -10,
      blurRadius: 14,
    )
  ],
);

BoxDecoration kdecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(32),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

BoxDecoration mdecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(16),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 3,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

BoxDecoration kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  border: Border.all(width: 0.3, color: Colors.black26),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 0),
      color: Colors.black,
      spreadRadius: -10,
      blurRadius: 14,
    )
  ],
);
