import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:flutter/services.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    // Detect system brightness mode and set the initial theme accordingly
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData getThemeData() {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
            scaffoldBackgroundColor:
                Colors.black, // Set dark mode background color
          )
        : ThemeData.light().copyWith(
            scaffoldBackgroundColor:
                Colors.white, // Set light mode background color
          );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
