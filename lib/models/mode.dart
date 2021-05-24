import 'package:flutter/foundation.dart';

class Mode extends ChangeNotifier {
  bool _darkMode = false;

  get isDarkMode => _darkMode;
  get isLightMode => !_darkMode;

  toggleMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
