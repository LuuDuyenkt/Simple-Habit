import 'package:flutter/material.dart';
import 'walk_task_card.dart';
import 'drink_task_card.dart';

class TaskPage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onToggle;
  final Function(String) onAddTask;
  final Function(int) onDelete;
  final int selectedDateIndex;
  final Function(int) onSelectDate;
  final List<int> calendarDates;
  final List<String> calendarDayNames;
  final List<String> lunarDates;
  final String calendarHeader;
  final int currentWeekOffset;
  final Function(int) onChangeWeek;
  final List<double> dailyCompletion;
  final Map<String, int> walkStepsByDate;
  final VoidCallback onWalkChanged;
  final Map<String, String> walkFeelByDate;
  final Map<String, int> drinkMlByDate;
  final Map<String, String> drinkFeelByDate;

  const TaskPage({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onAddTask,
    required this.onDelete,
    required this.selectedDateIndex,
    required this.onSelectDate,
    required this.calendarDates,
    required this.calendarDayNames,
    required this.lunarDates,
    required this.calendarHeader,
    required this.currentWeekOffset,
    required this.onChangeWeek,
    required this.dailyCompletion,
    required this.walkStepsByDate,
    required this.onWalkChanged,
    required this.walkFeelByDate,
    required this.drinkMlByDate,
    required this.drinkFeelByDate,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  DateTime selectedDate = DateTime.now();
  int selectedDateIndex = 2;
  void _showAddDialog() {
    String newTask = '';

    showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            onChanged: (value) {
              newTask = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: [
        //     TextButton(
        //       onPressed: () {
        //         if (newTask.isNotEmpty) {
        //           widget.onAddTask(newTask);
        //         }
        //         Navigator.pop(context);},
        //       child: const Text('Add'),
        // ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  widget.onAddTask(newTask);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  DateTime _getSelectedDate() {
    final now = DateTime.now();
    final baseDate = now.add(Duration(days: widget.currentWeekOffset * 7));
    final startOfWeek =
    baseDate.subtract(Duration(days: baseDate.weekday - 1));

    return startOfWeek.add(Duration(days: widget.selectedDateIndex));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddDialog();
      //   },
      //   backgroundColor: const Color(0xFF7C74F8),
      //   child: const Icon(Icons.add),
      // ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Today Tasks',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 16),
              _buildCalendar(),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: widget.tasks.asMap().entries.map((entry) {
                        final index = entry.key;
                        final task = entry.value;

                        // return _task(
                        //   task['title'],
                        //   task['done'],
                        //       () {
                        //     widget.onToggle(index);
                        //   },
                        //       () {
                        //     widget.onDelete(index);
                        //   },
                        // );
                        final title = task['title'].toString();

                        if (title.toLowerCase().contains('walk')) {
                          return WalkTaskCard(
                              title: title,
                              selectedDate: _getSelectedDate(),
                              walkStepsByDate:  widget.walkStepsByDate,
                              onWalkChanged: widget.onWalkChanged,
                              walkFeelByDate: widget.walkFeelByDate,
                          );
                        }

                        if (title.toLowerCase().contains('drink')) {
                          return DrinkTaskCard(
                            title: title,
                            selectedDate: _getSelectedDate(),
                            drinkMlByDate: widget.drinkMlByDate,
                            drinkFeelByDate: widget.drinkFeelByDate,
                            onDrinkChanged: () {
                              widget.onWalkChanged(); // reuse luôn
                            },
                          );
                        }

                        return _task(
                          task['title'],
                          task['done'],
                              () {
                            widget.onToggle(index);
                          },
                              () {
                            widget.onDelete(index);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateDetail(int index) {
    final now = DateTime.now();

    final baseDate = now.add(Duration(days: widget.currentWeekOffset * 7));
    final startOfWeek =
    baseDate.subtract(Duration(days: baseDate.weekday - 1));

    final selectedDate = startOfWeek.add(Duration(days: index));

    final dayName = widget.calendarDayNames[index];
    final lunar = widget.lunarDates[index];

    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final month = monthNames[selectedDate.month - 1];
    final date = selectedDate.day;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$month   $dayName',
                  style: TextStyle(
                    fontSize: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$date',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lunar,
                  style: TextStyle(
                    fontSize: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStar(double percent) {
    if (percent == -1) {
      return Icon(
        Icons.star,
        color: Colors.grey.shade300,
        size: 16,
      );
    }

    if (percent == 0) {
      return  Icon(
        Icons.star_border,
        color: Colors.grey.shade400,
        size: 16,
      );
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Icon(
          Icons.star,
          color: Colors.grey.shade300,
          size: 16,
        ),
        ClipRect(
          clipper: _StarClipper(percent),
          child: const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _task(
      String title,
      bool done,
      VoidCallback onTap,
      VoidCallback onDelete,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: done
              ? const Color(0xFFEDEBFF)
              : Theme.of(context).cardColor, // ✨ FIX DARK MODE
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done
                  ? const Color(0xFF7C74F8)
                  : Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),

            const SizedBox(width: 12),

            /// ✨ FIX tràn + màu chữ
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: done
                      ? const Color(0xFF7C74F8)
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            /// ✨ FIX icon delete
            // IconButton(
            //   onPressed: onDelete,
            //   icon: Icon(
            //     Icons.delete_outline,
            //     color: Colors.redAccent.withOpacity(0.8),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    // final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // final dates = [2, 3, 4, 5, 6, 7, 8]; // dương
    final days = widget.calendarDayNames;
    final dates = widget.calendarDates;
    // final lunar = ['20', '21', '22', '23', '24', '25', '26']; // âm (fake)
    final lunar = widget.lunarDates;

    // final todayIndex = selectedDateIndex;

    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: List.generate(7, (index) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.currentWeekOffset > -2
                ? () => widget.onChangeWeek(-1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            widget.calendarHeader,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          IconButton(
            onPressed: widget.currentWeekOffset < 2
                ? () => widget.onChangeWeek(1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final percent = widget.dailyCompletion[index];

          final isToday = index == widget.selectedDateIndex;
          return GestureDetector(
            onTap: () {
              // setState(() {
              //   selectedDateIndex = index;
              // });
              widget.onSelectDate(index);
            },
            onLongPress: (){
              _showDateDetail(index);
            },
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isToday
                        ? const Color(0xFF7C74F8)
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 42,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFF7C74F8)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isToday
                        ? [
                      BoxShadow(
                        color: const Color(0xFF7C74F8).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${dates[index]}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),

                      // Text(
                      //   lunar[index],
                      //   style: TextStyle(
                      //     fontSize: 10,
                      //     color: Colors.black45,
                      //   ),
                      // ),

                      const SizedBox(height: 2),
                      Text(
                        lunar[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: isToday
                              ? const Color(0xFF7C74F8)
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:4),
                _buildStar(percent),
              ],
            ),
          );
           }),
         ),
        ],
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double percent;

  _StarClipper(this.percent);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * percent, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.percent != percent;
  }
}


