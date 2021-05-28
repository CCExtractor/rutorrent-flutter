import 'package:flutter/material.dart';
import 'constants.dart';

class Themes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'SFUIDisplay',
          ),
      brightness: Brightness.dark,
      primaryColor: kBluePrimaryLT,
      accentColor: kIndigoSecondaryLT,
      disabledColor: kGreyLT,
      backgroundColor: Colors.white,
      toggleableActiveColor: kIndigoSecondaryLT,
      dialogBackgroundColor: Colors.white,
      cardColor: Colors.white);
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        scaffoldBackgroundColor: kBackgroundDT,
        canvasColor: kBackgroundDT,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'SFUIDisplay',
            ),
        brightness: Brightness.dark,
        backgroundColor: kBackgroundDT,
        primaryColor: kPrimaryDT,
        accentColor: kSecondaryDT,
        disabledColor: kGreyDT,
        cardColor: kGreyDT,
        toggleableActiveColor: kSecondaryDT,
      );
}
