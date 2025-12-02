import 'package:el_impostor_app/core/services/settings_storage_service.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _isDarkMode = await SettingsStorageService.loadTheme();
    AppColors.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    AppColors.setDarkMode(_isDarkMode);
    SettingsStorageService.saveTheme(_isDarkMode);
    notifyListeners();
  }
}
