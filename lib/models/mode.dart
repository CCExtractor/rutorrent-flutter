import 'package:flutter/foundation.dart';

class Mode extends ChangeNotifier {
  static bool _darkMode = false;

  static bool get isDarkMode => _darkMode;
  static bool get isLightMode => !_darkMode;

  toggleMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
