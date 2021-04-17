import 'package:flutter/foundation.dart';

class Mode extends ChangeNotifier {
  bool _darkMode = false;

  bool get isDarkMode => _darkMode;
  bool get isLightMode => !_darkMode;

  void toggleMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
