import 'package:flutter/material.dart';

class AppState {
  static bool appReminderOn = true;
  static bool isDarkMode = false;
  static final ValueNotifier<bool> darkModeNotifier =
  ValueNotifier<bool>(false);
}