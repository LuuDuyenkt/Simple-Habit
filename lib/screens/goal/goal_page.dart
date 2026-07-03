import 'package:flutter/material.dart';
import 'package:habit_with_me/services/notification_service.dart';
import '../../app_state.dart';

class GoalPage extends StatefulWidget {

  final List<Map<String, dynamic>> goals;
  final Function(String, String, List<String>, bool, int, int) onAddGoal;
  final Function(String) onDeleteGoal;
  final Function(String, String, String, List<String>, bool, int, int) onEditGoal;

  const GoalPage({
    super.key,
    required this.goals,
    required this.onAddGoal,
    required this.onDeleteGoal,
    required this.onEditGoal,

  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  void _showAddDialog() {
    final TextEditingController goalController = TextEditingController();
    String selectedFrequency = 'Daily';
    List<String> selectedDays = [];
    bool reminderOn = false;
    TimeOfDay reminderTime = const TimeOfDay(hour: 7, minute: 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Goal'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: goalController,
                        decoration: const InputDecoration(
                          hintText: 'Enter goal name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedFrequency,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedFrequency = value;
                            if (selectedFrequency == 'Daily') {
                              selectedDays = [];
                            }
                          });
                        },
                      ),
                      if (selectedFrequency == 'Weekly') ...[
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ].map((day) {
                              final isSelected = selectedDays.contains(day);

                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    if (isSelected) {
                                      selectedDays.remove(day);
                                    } else {
                                      selectedDays.add(day);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7C74F8)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF7C74F8)
                                          : Colors.black26,
                                    ),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Reminder'),
                        value: reminderOn,
                        onChanged: (value) {
                          setDialogState(() {
                            reminderOn = value;
                          });
                        },
                      ),

                      if (reminderOn)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Reminder time'),
                          subtitle: Text(
                            '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}',
                          ),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: reminderTime,
                            );

                            if (picked != null) {
                              setDialogState(() {
                                reminderTime = picked;
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // add new Goal
                    final newGoal = goalController.text.trim();

                    if (newGoal.isEmpty) return;

                    if (selectedFrequency == 'Weekly' &&
                        selectedDays.isEmpty) {
                      return;
                    }

                    widget.onAddGoal(
                      newGoal,
                      selectedFrequency,
                      selectedDays,
                      reminderOn,
                      reminderTime.hour,
                      reminderTime.minute,
                    );


                    // 2. gọi schedule notification
                    final now = DateTime.now();

                    int newMinute = now.minute + 1;
                    int newHour = now.hour;

                    if (newMinute >= 60) {
                      newMinute = 0;
                      newHour = (newHour + 1) % 24;
                    }

                    if (AppState.appReminderOn && reminderOn) {
                      NotificationService.scheduleReminder(
                        id: 1,
                        title: "Reminder",
                        body: "Đến giờ làm habit rồi 💪",
                        hour: newHour,
                        minute: newMinute,
                      );
                    }


                    // 3 Đóng dialog
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
      String oldTitle,
      String currentTitle,
      String currentFrequency,
      List currentDays,
      bool currentReminderOn,
      int currentReminderHour,
      int currentReminderMinute,
      ) {
    final TextEditingController goalController =
    TextEditingController(text: currentTitle);

    String selectedFrequency = currentFrequency;
    List<String> selectedDays = List<String>.from(currentDays);
    bool reminderOn = currentReminderOn;
    TimeOfDay reminderTime = TimeOfDay(
      hour: currentReminderHour,
      minute: currentReminderMinute,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Goal'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: goalController,
                        decoration: const InputDecoration(
                          hintText: 'Enter goal name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedFrequency,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Text('Weekly'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedFrequency = value;
                            if (selectedFrequency == 'Daily') {
                              selectedDays = [];
                            }
                          });
                        },
                      ),
                      if (selectedFrequency == 'Weekly') ...[
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ].map((day) {
                              final isSelected = selectedDays.contains(day);

                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    if (isSelected) {
                                      selectedDays.remove(day);
                                    } else {
                                      selectedDays.add(day);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7C74F8)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF7C74F8)
                                          : Colors.black26,
                                    ),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Reminder'),
                        value: reminderOn,
                        onChanged: (value) {
                          setDialogState(() {
                            reminderOn = value;
                          });
                        },
                      ),

                      if (reminderOn)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Reminder time'),
                          subtitle: Text(
                            '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}',
                          ),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: reminderTime,
                            );

                            if (picked != null) {
                              setDialogState(() {
                                reminderTime = picked;
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final editedTitle = goalController.text.trim();

                    if (editedTitle.isEmpty) return;

                    if (selectedFrequency == 'Weekly' &&
                        selectedDays.isEmpty) {
                      return;
                    }

                    widget.onEditGoal(
                      oldTitle,
                      editedTitle,
                      selectedFrequency,
                      selectedDays,
                      reminderOn,
                      reminderTime.hour,
                      reminderTime.minute,
                    );

                    Navigator.pop(context);
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

  Widget _goalItem(Map<String, dynamic> goal) {
    bool isAppOn = AppState.appReminderOn;
    bool isGoalOn = AppState.appReminderOn && (goal['reminderOn'] ?? false);

    final title = goal['title'];
    final frequency = goal['frequency'];
    final days = goal['days'] ?? [];
    final reminderOn = goal['reminderOn'] ?? false;
    final reminderHour = goal['reminderHour'] ?? 7;
    final reminderMinute = goal['reminderMinute'] ?? 0;

    String reminderText;
    Color reminderColor;

    if (goal['reminderOn'] == true && AppState.appReminderOn) {
      reminderText =
      'Reminder: On • ${reminderHour.toString().padLeft(2, '0')}:${reminderMinute.toString().padLeft(2, '0')}';
      reminderColor = const Color(0xFF7C74F8);
    } else if (goal['reminderOn'] == true && !AppState.appReminderOn) {
      reminderText =
      'Reminder: Paused • ${reminderHour.toString().padLeft(2, '0')}:${reminderMinute.toString().padLeft(2, '0')}';
      reminderColor =
          Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.75) ??
              Colors.white70;
    } else {
      reminderText = 'No reminder';
      reminderColor =
          Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.75) ??
              Colors.white70;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )
                ),
                const SizedBox(height: 6),
                Text(
                  frequency == 'Weekly' && days.isNotEmpty
                      ? '$frequency • ${days.join(', ')}'
                      : frequency,
                  style: TextStyle(
                    fontSize: 13,
                    color: (isAppOn && isGoalOn)
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                // Text(
                //   isGoalOn
                //       ? 'Reminder: On • ${reminderHour.toString().padLeft(2, '0')}:${reminderMinute.toString().padLeft(2, '0')}'
                //       : 'Reminder: Off',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: isGoalOn ? const Color(0xFF7C74F8) : Colors.black38,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),

                Text(
                  reminderText,
                  style: TextStyle(
                    fontSize: 12,
                    color: reminderColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),


              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _showEditDialog(
                  title,
                  title,
                  frequency,
                  days,
                  reminderOn,
                  reminderHour,
                  reminderMinute,
                );
              } else if (value == 'delete') {
                widget.onDeleteGoal(title);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // NotificationService.showNotification(   - test với mục tiêu chỉ cần nhấn dấu  + là  hien reminder
          //   id: 1,
          //   title: "Reminder",
          //   body: "Đến giờ làm habit rồi 💪",
          // );

          _showAddDialog();
        },
        backgroundColor: const Color(0xFF7C74F8),
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            const SizedBox(height: 8),
            Text(
              'Your Goals',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            ...widget.goals
                .where((g) => g['deletedAt'] == null)
                .map((g) => _goalItem(g)),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}