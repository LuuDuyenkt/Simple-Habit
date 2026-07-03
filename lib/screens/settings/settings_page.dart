import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import '../../app_state.dart';
import 'package:habit_with_me/screens/profile/profile_page.dart';
import '../admin/admin_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  //final bool appReminderOn;
  //final Function(bool) onToggleReminder;
  final List<Map<String, dynamic>> tasks;

  const SettingsPage({
    super.key,
    //required this.appReminderOn,
    //required this.onToggleReminder,
    required this.tasks,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  String userName = 'User';
  bool darkModeOn = false;
  TimeOfDay reminderTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('userName') ?? 'User';
      AppState.appReminderOn = prefs.getBool('appReminderOn') ?? true;
      darkModeOn = prefs.getBool('darkModeOn') ?? false;
      AppState.darkModeNotifier.value = darkModeOn;

      final hour = prefs.getInt('reminderHour') ?? 7;
      final minute = prefs.getInt('reminderMinute') ?? 0;
      reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);

    setState(() {
      userName = name;
    });
  }

  Future<void> _saveReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('appReminderOn', value);

    setState(() {
      AppState.appReminderOn = value;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeOn', value);

    setState(() {
      darkModeOn = value;
    });

    AppState.darkModeNotifier.value = value;
  }

  Future<void> _saveReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderHour', time.hour);
    await prefs.setInt('reminderMinute', time.minute);

    setState(() {
      reminderTime = time;
    });
  }

  void _showEditProfileDialog() {
    final controller = TextEditingController(text: userName);

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text('Edit Profile'),
    //       content: TextField(
    //         controller: controller,
    //         decoration: const InputDecoration(
    //           hintText: 'Enter your name',
    //           border: OutlineInputBorder(),
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             final newName = controller.text.trim();
    //             if (newName.isNotEmpty) {
    //               _saveUserName(newName);
    //             }
    //             Navigator.pop(context);
    //           },
    //           child: const Text('Save'),
    //         ),
    //       ],
    //     );
    //   },
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _showDarkModeDialog() {
    bool tempDarkMode = darkModeOn;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                    title: const Text('Dark Mode'),
                    content: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Enable dark mode'),
                      value: tempDarkMode,
                      onChanged: (value) {
                        setDialogState(() {
                          tempDarkMode = value;
                        });
                      },
                    ),
                    actions: [TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                      TextButton(
                        onPressed: () async {
                          await _saveDarkMode(tempDarkMode);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                );
              },
          );
        },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }


  Widget _settingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF7C74F8)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderText =
    AppState.appReminderOn
        ? 'On • ${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}'
        : 'Off';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const SizedBox(height: 8),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                _settingTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: _showEditProfileDialog,
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SwitchListTile(
                    secondary: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF7C74F8),
                    ),
                    title: const Text(
                      'App Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      AppState.appReminderOn ? 'On' : 'Off',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    value: AppState.appReminderOn,
                    onChanged: (value) async {
                      await _saveReminder(value);
                    },
                    activeColor: const Color(0xFF7C74F8),
                  ),
                ),


                _settingTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',subtitle: darkModeOn ? 'On' : 'Off',
                  onTap: _showDarkModeDialog,
                ),
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings, color: const Color(0xFF7C74F8)),
                        title: const Text("Admin"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminPage(tasks: widget.tasks),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.feedback_outlined,
                          color: Color(0xFF7C74F8),
                        ),
                        title: const Text('Feedback'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final url = Uri.parse('https://forms.gle/NVPF1KdrzCfjopyYA');

                          try {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            print('Cannot open link');
                          }
                        },
                      ),
                      _settingTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: _logout,
                      ),



                    ],
                ),
            ),
        ),
    );
  }
}