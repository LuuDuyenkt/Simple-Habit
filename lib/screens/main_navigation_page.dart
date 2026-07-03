import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'task/task_page.dart';
import 'goal/goal_page.dart';
import 'settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:vnlunar/vnlunar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}


String getDateKey(DateTime date) {
  return "${date.year}-${date.month}-${date.day}";
}

String _monthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}


class _MainNavigationPageState extends State<MainNavigationPage> {
  Map<String, int> walkStepsByDate = {};
  //bool appReminderOn = true;
  Map<String, String> walkFeelByDate = {};
  Map<String, int> drinkMlByDate = {};
  Map<String, String> drinkFeelByDate = {};
  int currentIndex = 0;
  // int selectedDateIndex = 2;
  int selectedDateIndex = DateTime.now().weekday - 1;
  int currentWeekOffset = 0;

  //Map<String, Set<int>> doneByDate = {};
  Map<String, Set<String>> doneByDate = {};

  List<Map<String, dynamic>> goals = [
    {
      'title': 'Drink water',
      'frequency': 'Daily',
      'days': <String>[],
      'reminderOn': true,
      'reminderHour': 8,
      'reminderMinute': 0,
    },
    {
      'title': 'Exercise',
      'frequency': 'Weekly',
      'days': <String>['Mon', 'Wed', 'Fri'],
      'reminderOn': false,
      'reminderHour': 18,
      'reminderMinute': 0,
    },
  ];

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final goalsString = jsonEncode(goals);
    await prefs.setString('goals', goalsString);

    final doneMap = doneByDate.map(
          (key, value) => MapEntry(key, value.toList()),
    );

    final doneString = jsonEncode(doneMap);
    await prefs.setString('doneByDate', doneString);

    final walkString = jsonEncode(walkStepsByDate);
    await prefs.setString('walkStepsByDate', walkString);

    final walkFeelString = jsonEncode(walkFeelByDate);
    await prefs.setString('walkFeelByDate', walkFeelString);

    final drinkString = jsonEncode(drinkMlByDate);
    await prefs.setString('drinkMlByDate', drinkString);

    final drinkFeelString = jsonEncode(drinkFeelByDate);
    await prefs.setString('drinkFeelByDate', drinkFeelString);

  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final goalsString = prefs.getString('goals');
    final doneString = prefs.getString('doneByDate');
    final walkString = prefs.getString('walkStepsByDate');
    final walkFeelString = prefs.getString('walkFeelByDate');
    final drinkString = prefs.getString('drinkMlByDate');
    final drinkFeelString = prefs.getString('drinkFeelByDate');

    if (walkString != null) {
      final decoded = jsonDecode(walkString);
      walkStepsByDate =
      Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v)));
    }

    if (goalsString != null) {
      final decodedGoals = jsonDecode(goalsString);
      goals = List<Map<String, dynamic>>.from(decodedGoals);
    }

    if (doneString != null) {
      final decodedDone = jsonDecode(doneString);

      doneByDate = (decodedDone as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,

          // Set<int>.from(value),
          Set<String>.from(value),
        ),
      );
    }
    if (walkFeelString != null) {
      final decodedFeel = jsonDecode(walkFeelString);

      walkFeelByDate = (decodedFeel as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value.toString()),
      );
    }

    if (drinkString != null) {
      final decodedDrink = jsonDecode(drinkString);

      drinkMlByDate = (decodedDrink as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as int),
      );
    }

    if (drinkFeelString != null) {
      final decodedDrinkFeel = jsonDecode(drinkFeelString);

      drinkFeelByDate = (decodedDrinkFeel as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value.toString()),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // void addGoal(String title, String frequency, List<String> days) {
  //   setState(() {
  //     goals.add({
  //       'title': title,
  //       'frequency': frequency,
  //       'days': days,
  //     });
  //   });
  // }
  void addGoal(
      String title,
      String frequency,
      List<String> days,
      bool reminderOn,
      int reminderHour,
      int reminderMinute,
      ) {
    setState(() {
      goals.add({
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'title': title,
        'frequency': frequency,
        'days': days,
        'reminderOn': reminderOn,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'createdAt': DateTime.now().toIso8601String(),
        'deletedAt': null,
      });
    });
    saveData();
  }

  // void deleteGoal(String title) {
  //   setState(() {
  //     goals.removeWhere((g) => g['title'] == title);
  //     doneByDate.remove(title);
  //   });
  // }
  void deleteGoal(String title) {
    setState(() {
      final index = goals.indexWhere(
            (g) => g['title'] == title && g['deletedAt'] == null,
      );

      if (index != -1) {
        goals[index]['deletedAt'] = DateTime.now().toIso8601String();
      }
    });

    saveData();
  }

  void editGoal(
      String oldTitle,
      String newTitle,
      String frequency,
      List<String> days,
      bool reminderOn,
      int reminderHour,
      int reminderMinute,
      ) {
    setState(() {
      final index = goals.indexWhere((g) => g['title'] == oldTitle);
      if (index != -1) {
        goals[index] = {
          'id': goals[index]['id'],
          'title': newTitle,
          'frequency': frequency,
          'days': days,
          'reminderOn': reminderOn,
          'reminderHour': reminderHour,
          'reminderMinute': reminderMinute,
          'createdAt': goals[index]['createdAt'],
          'deletedAt': goals[index]['deletedAt'],
        };

        if (oldTitle != newTitle && doneByDate.containsKey(oldTitle)) {
          doneByDate[newTitle] = doneByDate[oldTitle]!;
          doneByDate.remove(oldTitle);
        }
      }
    });
    saveData();
  }



  @override
  Widget build(BuildContext context) {
    // final int day = 2; // tạm thời đang fix = Wed
    // final int day = selectedDateIndex;
    //
    // final List<String> dayNames = [
    //   'Mon',
    //   'Tue',
    //   'Wed',
    //   'Thu',
    //   'Fri',
    //   'Sat',
    //   'Sun',
    // ];
    //
    // final String currentDayName = dayNames[day];

    // TEST LỊCH ÂM - OKE
    // final now = DateTime.now();
    //
    // final List<int> lunarTest = convertSolar2Lunar(
    //   now.day,
    //   now.month,
    //   now.year,
    //   7,
    // );
    //
    // print('Lunar day: ${lunarTest[0]}');
    // print('Lunar month: ${lunarTest[1]}');
    // print('Lunar year: ${lunarTest[2]}');
    // print('Leap: ${lunarTest[3]}');
    // END TEST
    // final now = DateTime.now();
    //
    // final int day = selectedDateIndex;
    //
    // final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final now = DateTime.now();
    final int day = selectedDateIndex;

    final baseDate = now.add(Duration(days: currentWeekOffset * 7));
    final startOfWeek =
    baseDate.subtract(Duration(days: baseDate.weekday - 1));

    final start = startOfWeek;
    final end = startOfWeek.add(const Duration(days: 6));

    String calendarHeader;

    if (start.month == end.month) {
      calendarHeader = "${_monthName(start.month)} ${start.year}";
    } else {
      calendarHeader =
      "${_monthName(start.month)} – ${_monthName(end.month)} ${start.year}";
    }


    final lunarDates = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));

      final lunar = convertSolar2Lunar(
        date.day,
        date.month,
        date.year,
        7,
      );

      return '${lunar[0]}/${lunar[1]}';
    });


    final calendarDates = List.generate(
      7,
          (index) => startOfWeek.add(Duration(days: index)).day,
    );

    final calendarDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final String currentDayName = calendarDayNames[day];



    final filteredGoals = goals.where((g) {
      final selectedDate = startOfWeek.add(Duration(days: day));

      final selectedOnlyDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      final createdAt = DateTime.tryParse(g['createdAt'] ?? '');
      if (createdAt != null) {
        final createdOnlyDate = DateTime(
          createdAt.year,
          createdAt.month,
          createdAt.day,
        );

        if (selectedOnlyDate.isBefore(createdOnlyDate)) {
          return false;
        }
      }

      final deletedAt = DateTime.tryParse(g['deletedAt'] ?? '');
      if (deletedAt != null) {
        final deletedOnlyDate = DateTime(
          deletedAt.year,
          deletedAt.month,
          deletedAt.day,
        );

        if (!selectedOnlyDate.isBefore(deletedOnlyDate)) {
          return false;
        }
      }

      if (g['frequency'] == 'Daily') return true;

      final List days = g['days'] ?? [];
      return days.contains(currentDayName);
    }).toList();

    // final taskList = filteredGoals.map((g) {
    //   final title = g['title'];
    //
    //   return {
    //     'title': title,
    //     'done': doneByDate[title]?.contains(day) ?? false,
    //   };
    // }).toList();

    // ⭐ phần trăm hoàn thành cho từng ngày trong tuần đang xem
    final dailyCompletion = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      final dateKey = getDateKey(date);
      final dayName = calendarDayNames[index];

      final goalsOfDay = goals.where((g) {
        final selectedOnlyDate = DateTime(date.year, date.month, date.day);

        final createdAt = DateTime.tryParse(g['createdAt'] ?? '');
        if (createdAt != null) {
          final createdOnlyDate = DateTime(
            createdAt.year,
            createdAt.month,
            createdAt.day,
          );

          if (selectedOnlyDate.isBefore(createdOnlyDate)) return false;
        }

        final deletedAt = DateTime.tryParse(g['deletedAt'] ?? '');
        if (deletedAt != null) {
          final deletedOnlyDate = DateTime(
            deletedAt.year,
            deletedAt.month,
            deletedAt.day,
          );

          if (!selectedOnlyDate.isBefore(deletedOnlyDate)) return false;
        }

        if (g['frequency'] == 'Daily') return true;

        final List days = g['days'] ?? [];
        return days.contains(dayName);
      }).toList();

      final total = goalsOfDay.length;
      print('DATE $dateKey | TOTAL $total | GOALS ${goalsOfDay.map((g) => g['title']).toList()}');          //DELETE DELETE
      if (total == 0) return -1.0; // không có task

      int done = 0;

      for (var g in goalsOfDay) {
        final title = g['title'];

        // 🟣 xử lý riêng cho WALK
        if (title.toLowerCase().contains('walk')) {
          final steps = walkStepsByDate[dateKey] ?? 0;

          if (steps > 0) {
            done++; // chỉ cần có bước là tính hoàn thành
          }

        } else {
          // 🟢 task bình thường
          if (doneByDate[title]?.contains(dateKey) ?? false) {
            done++;
          }
        }

        // XỬ LÝ CHO DRINK
        if (title.toLowerCase().contains('drink')) {
          final ml = drinkMlByDate[dateKey] ?? 0;
          if (ml >= 1500) {
            done++;
          }
          continue;
        }
      }

      return done / total;
    });

    final taskList = filteredGoals.map((g) {
      final title = g['title'];

      final selectedDate =
      startOfWeek.add(Duration(days: day));

      final dateKey = getDateKey(selectedDate);

      return {
        'title': title,

        'done': title.toLowerCase().contains('walk')
            ? (walkStepsByDate[dateKey] ?? 0) > 0
            : doneByDate[title]?.contains(dateKey) ?? false,
      };


    }).toList();

    final today = DateTime.now();
    final todayDateKey = getDateKey(today);
    final todayDayName = calendarDayNames[today.weekday - 1];

    final todayGoals = goals.where((g) {
      final todayOnlyDate = DateTime(today.year, today.month, today.day);

      final createdAt = DateTime.tryParse(g['createdAt'] ?? '');
      if (createdAt != null) {
        final createdOnlyDate = DateTime(createdAt.year, createdAt.month, createdAt.day);
        if (todayOnlyDate.isBefore(createdOnlyDate)) return false;
      }

      final deletedAt = DateTime.tryParse(g['deletedAt'] ?? '');
      if (deletedAt != null) {
        final deletedOnlyDate = DateTime(deletedAt.year, deletedAt.month, deletedAt.day);
        if (!todayOnlyDate.isBefore(deletedOnlyDate)) return false;
      }

      if (g['frequency'] == 'Daily') return true;

      final List days = g['days'] ?? [];
      return days.contains(todayDayName);
    }).toList();

    final todayTaskList = todayGoals.map((g) {
      final title = g['title'];

      return {
        'title': title,
        'done': title.toLowerCase().contains('walk')
            ? (walkStepsByDate[todayDateKey] ?? 0) > 0
            : doneByDate[title]?.contains(todayDateKey) ?? false,

        'steps': title.toLowerCase().contains('walk')
            ? (walkStepsByDate[todayDateKey] ?? 0)
            : 0,
        'ml': title.toLowerCase().contains('drink')
            ? (drinkMlByDate[todayDateKey] ?? 0)
            : 0,
      };
    }).toList();

    final pages = [
      HomePage(
        tasks: todayTaskList,
        onStart: () {
          setState(() {
            currentIndex = 1; // chuyển sang tab Task
          });
        },
        walkStepsByDate: walkStepsByDate,
      ),

      TaskPage(
        walkFeelByDate: walkFeelByDate,
        walkStepsByDate: walkStepsByDate,
        drinkMlByDate: drinkMlByDate,
        drinkFeelByDate: drinkFeelByDate,
        lunarDates: lunarDates,
        tasks: taskList,
        dailyCompletion: dailyCompletion,
        onWalkChanged: (){
          setState(() {

          });
          saveData();
        },


        // onToggle: (index) {
        //   setState()
        //   final title = filteredGoals[index]['title'];
        //
        //   final selectedDate =
        //   startOfWeek.add(Duration(days: selectedDateIndex));
        //
        //   final dateKey = getDateKey(selectedDate);
        //
        //   setState(() {
        //     doneByDate.putIfAbsent(title, () => <String>{});
        //
        //     if (doneByDate[title]!.contains(dateKey)) {
        //       doneByDate[title]!.remove(dateKey);
        //     } else {
        //       doneByDate[title]!.add(dateKey);
        //     }
        //   });
        //
        //   saveData();
        // },
        onToggle: (index) {
          setState(() {   // 👈 THÊM CÁI NÀY
            final title = filteredGoals[index]['title'];

            final selectedDate =
            startOfWeek.add(Duration(days: selectedDateIndex));

            final dateKey = getDateKey(selectedDate);

            doneByDate.putIfAbsent(title, () => <String>{});

            if (doneByDate[title]!.contains(dateKey)) {
              doneByDate[title]!.remove(dateKey);
            } else {
              doneByDate[title]!.add(dateKey);
            }
          });

          saveData();
        },

        // onAddTask: (title) {
        //   setState(() {
        //     goals.add({
        //       'title': title,
        //       'frequency': 'Daily',
        //       'days': <String>[],
        //     });
        //   });
        // },
        onAddTask: (title) {
          setState(() {
            goals.add({
              'title': title,
              'frequency': 'Daily',
              'days': <String>[],
            });
          });
          saveData();
        },

        // onDelete: (index) {
        //   final title = filteredGoals[index]['title'];
        //
        //   setState(() {
        //     goals.removeWhere((g) => g['title'] == title);
        //     doneByDate.remove(title);
        //   });
        // },
        onDelete: (index) {
          final title = filteredGoals[index]['title'];

          setState(() {
            goals.removeWhere((g) => g['title'] == title);
            doneByDate.remove(title);
          });
          saveData();
        },

        selectedDateIndex: selectedDateIndex,
        onSelectDate: (index) {
          setState(() {
            selectedDateIndex = index;
          });
        },

        calendarDates: calendarDates,
        calendarDayNames: calendarDayNames,

        // lunarDates: lunarDates,
        calendarHeader: calendarHeader,
        currentWeekOffset: currentWeekOffset,
        onChangeWeek: (value) {
          setState(() {
            final newOffset = currentWeekOffset + value;
            if (newOffset >= -2 && newOffset <= 2) {
              currentWeekOffset = newOffset;
            }
          });
        },

      ),

      GoalPage(
        goals: goals,
        onAddGoal: addGoal,
        onDeleteGoal: deleteGoal,
        onEditGoal: editGoal,
      ),

      SettingsPage(tasks: taskList),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF7C74F8),
            unselectedItemColor:
            Theme.of(context).iconTheme.color?.withOpacity(0.5),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                activeIcon: Icon(Icons.check_circle),
                label: 'Task',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag_outlined),
                activeIcon: Icon(Icons.flag),
                label: 'Goal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );


  }




}