import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'package:habit_with_me/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await NotificationService.init();
//   await Permission.notification.request();
//
//   runApp(const SimpleHabitApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await Permission.notification.request();

  final prefs = await SharedPreferences.getInstance();
  final savedDarkMode = prefs.getBool('darkModeOn') ?? false;
  final savedAppReminder = prefs.getBool('appReminderOn') ?? true;

  AppState.isDarkMode = savedDarkMode;
  AppState.darkModeNotifier.value = savedDarkMode;
  AppState.appReminderOn = savedAppReminder;

  runApp(const SimpleHabitApp());
}

class SimpleHabitApp extends StatelessWidget {
  const SimpleHabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.darkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple Habit',

          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),

          home: const LoginPage(),
        );
      },
    );
  }
}
