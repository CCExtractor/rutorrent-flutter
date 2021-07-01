import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
    primaryColor: kBluePrimaryLT,
    accentColor: kIndigoSecondaryLT,
    disabledColor: kGreyLT,
    toggleableActiveColor: kIndigoSecondaryLT,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kBackgroundDT,
    canvasColor: kBackgroundDT,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
    primaryColor: kPrimaryDT,
    accentColor: kSecondaryDT,
    disabledColor: kGreyDT,
    toggleableActiveColor: kSecondaryDT,
  );
}
