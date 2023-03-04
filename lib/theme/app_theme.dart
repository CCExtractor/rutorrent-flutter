import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
    primaryColor: kBluePrimaryLT,
    disabledColor: kGreyLT,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: kIndigoSecondaryLT),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kIndigoSecondaryLT;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kIndigoSecondaryLT;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kIndigoSecondaryLT;
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return kIndigoSecondaryLT;
        }
        return null;
      }),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kBackgroundDT,
    canvasColor: kBackgroundDT,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SFUIDisplay',
        ),
    primaryColor: kPrimaryDT,
    disabledColor: kGreyDT,
    toggleableActiveColor: kSecondaryDT,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kSecondaryDT),
  );
}
