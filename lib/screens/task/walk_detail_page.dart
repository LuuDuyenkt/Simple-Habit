import 'dart:math';
import 'package:flutter/material.dart';

class WalkDetailPage extends StatefulWidget {
  final int initialSteps;
  final int targetSteps;
  final String initialFeel;
  final DateTime selectedDate;
  final Map<String, int> walkStepsByDate;

  const WalkDetailPage({
    super.key,
    required this.initialSteps,
    required this.targetSteps,
    required this.initialFeel,
    required this.selectedDate,
    required this.walkStepsByDate,
  });

  @override
  State<WalkDetailPage> createState() => _WalkDetailPageState();
}

class _WalkDetailPageState extends State<WalkDetailPage> {
  late int steps;
  late String feel;
  final TextEditingController inputController = TextEditingController();
  final TextEditingController feelController = TextEditingController();

  final List<int> undoStack = [];

  String getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  int calculateWalkStreak() {
    int streak = 0;
    DateTime current = widget.selectedDate;

    final todayKey = getDateKey(current);
    final todaySteps = widget.walkStepsByDate[todayKey] ?? 0;

    // Nếu ngày đang xem chưa đạt mục tiêu → bắt đầu đếm từ hôm trước
    if (todaySteps < widget.targetSteps) {
      current = current.subtract(const Duration(days: 1));
    }

    while (true) {
      final key = getDateKey(current);
      final stepsOfDay = widget.walkStepsByDate[key] ?? 0;

      if (stepsOfDay >= widget.targetSteps) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int calculateTotalWalkDays() {
    return widget.walkStepsByDate.values.where((steps) => steps > 0).length;
  }

  @override
  void initState() {
    super.initState();
    steps = widget.initialSteps;
    feel = widget.initialFeel;
    feelController.text = feel;
  }

  void _addSteps(int value) {
    setState(() {
      undoStack.add(steps);
      steps = max(0, steps + value);
    });
  }

  void _resetSteps() {
    setState(() {
      undoStack.add(steps);
      steps = 0;
    });
  }

  void _undo() {
    if (undoStack.isEmpty) return;
    setState(() {
      steps = undoStack.removeLast();
    });
  }

  void _submitInput(String value) {
    final number = int.tryParse(value.trim());
    if (number == null) return;

    _addSteps(number);
    inputController.clear();
  }
  @override
  Widget build(BuildContext context) {
    final progress = steps / widget.targetSteps;
    final percent = (progress * 100).round();
    final walkStreak = calculateWalkStreak();
    const primary = Color(0xFF7C74F8);

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Walk'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'steps': steps,
                  'feel': feelController.text.trim(),
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
              children: [
              const SizedBox(height: 10),

          CustomPaint(
            size: const Size(210, 210),
            painter: _CircleProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              color: primary,
            ),
            child: SizedBox(
              width: 210,
              height: 210,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_walk, size: 34, color: primary),
                    const SizedBox(height: 8),
                    Text(
                      '$steps / ${widget.targetSteps}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'steps',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _quickButton('+100', () => _addSteps(100)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _quickButton('-100', () => _addSteps(-100)),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: _submitInput,
              decoration: InputDecoration(
                hintText: 'Enter steps',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                prefixIcon: const Icon(Icons.edit_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _undo,
                    icon: const Icon(Icons.undo),
                    label: const Text('Undo'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetSteps,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How do you feel today?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['😄', '🙂', '😐', '😫'].map((emoji) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          feelController.text = emoji;
                        });
                      },
                      child: Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                      ),
                  );
                }).toList(),
            ),

          const SizedBox(height: 14),

          TextField(
            controller: feelController,
            decoration: InputDecoration(
              hintText: 'Write your feeling...',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _smallInfoCard(
                        context,
                        icon: Icons.local_fire_department,
                        title: 'Streak',
                        value: '$walkStreak days',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _smallInfoCard(
                        context,
                        icon: Icons.calendar_month,
                        title: 'Total',
                        value: '${calculateTotalWalkDays()} days',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _miniChart(),
                const SizedBox(height: 16),

                const Text(
                  "This Week",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                ...List.generate(7, (i) {
                  final date = widget.selectedDate.subtract(Duration(days: i));
                  final key = "${date.year}-${date.month}-${date.day}";

                  final steps = widget.walkStepsByDate[key] ?? 0;

                  final dayName = ['Sun','Sat','Fri','Thu','Wed','Tue','Mon'][i];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dayName),
                        Text("${steps} steps"),
                      ],
                    ),
                  );
                }),
              ],
          ),
        ),
    );
  }

  Widget _quickButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEDEBFF),
        foregroundColor: const Color(0xFF7C74F8),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _smallInfoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7C74F8)),
          const SizedBox(height: 6),
          Text(title),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _miniChart() {
    final List<double> values = [];

    for (int i = 6; i >= 0; i--) {
      final date = widget.selectedDate.subtract(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";

      final steps = widget.walkStepsByDate[key] ?? 0;
      final maxSteps = 12000;
      final value = steps / maxSteps;

      values.add(value);
    }

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weekly Progress",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final v = values[index];
            final isToday = index == 6;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 14,
                  height: 80 * v.clamp(0.0, 1.2),
                  decoration: BoxDecoration(
                    color: isToday
                        ? Colors.blue
                        : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isToday ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = color.withOpacity(0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
