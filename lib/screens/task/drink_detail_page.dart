import 'dart:math';
import 'package:flutter/material.dart';

class DrinkDetailPage extends StatefulWidget {
  final int initialMl;
  final DateTime selectedDate;
  final Map<String, int> drinkMlByDate;
  const DrinkDetailPage({
    super.key,
    required this.initialMl,
    required this.selectedDate,
    required this.drinkMlByDate,
  });

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  late int ml;
  final int targetMl = 1500;
  final TextEditingController feelController = TextEditingController();
  final TextEditingController inputController = TextEditingController();
  final List<int> undoStack = [];

  @override
  void initState() {
    super.initState();
    ml = widget.initialMl;
  }

  void _addMl(int value) {
    setState(() {
      undoStack.add(ml);
      ml = max(0, ml + value);
    });
  }

  void _resetMl() {
    setState(() {
      undoStack.add(ml);
      ml = 0;
    });
  }

  void _undo() {
    if (undoStack.isEmpty) return;
    setState(() {
      ml = undoStack.removeLast();
    });
  }

  void _submitInput(String value) {
    final number = int.tryParse(value.trim());
    if (number == null) return;

    _addMl(number);
    inputController.clear();
  }
  String getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  int calculateDrinkStreak() {
    int streak = 0;
    DateTime current = widget.selectedDate;

    final todayKey = getDateKey(current);
    final todayMl = widget.drinkMlByDate[todayKey] ?? 0;

    if (todayMl < targetMl) {
      current = current.subtract(const Duration(days: 1));
    }

    while (true) {
      final key = getDateKey(current);
      final mlOfDay = widget.drinkMlByDate[key] ?? 0;

      if (mlOfDay >= targetMl) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int calculateTotalDrinkDays() {
    int total = 0;

    for (var entry in widget.drinkMlByDate.entries) {
      if (entry.value >= targetMl) {
        total++;
      }
    }

    return total;
  }


  @override
  Widget build(BuildContext context) {
    final progress = (ml / targetMl).clamp(0.0, 1.0);
    final percent = ((ml / targetMl) * 100).round();

    const primary = Color(0xFF7C74F8);
    const waterColor = Color(0xFF4FC3F7);

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Drink water'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, ml);
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

            const Text(
              '💧',
              style: TextStyle(fontSize: 34),
            ),

            const SizedBox(height: 10),

            Text(
              '$ml',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            Text(
              '/ $targetMl ml',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),

            const SizedBox(height: 22),
                  SizedBox(
                    width: 120,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // nền bình
                        Container(
                          width: 120,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),

                        // nước
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 120,
                          height: 200 * progress,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF81D4FA),
                                Color(0xFF29B6F6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),

                        // highlight (ánh sáng)
                        Positioned(
                          left: 20,
                          top: 30,
                          child: Container(
                            width: 12,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _quickButton('+100', () => _addMl(100)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickButton('+250', () => _addMl(250)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickButton('-100', () => _addMl(-100)),
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
                    hintText: 'Enter ml',
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
                          onPressed: _resetMl,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                          value: '${calculateDrinkStreak()} days',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _smallInfoCard(
                          context,
                          icon: Icons.calendar_month,
                          title: 'Total',
                          value: '${calculateTotalDrinkDays()} days',
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
                    final key = getDateKey(date);

                    final ml = widget.drinkMlByDate[key] ?? 0;

                    final dayName = ['Sun','Sat','Fri','Thu','Wed','Tue','Mon'][i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dayName),
                          Text("$ml ml"),
                        ],
                      ),
                    );
                  }),

                ],
            ),
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
      final key = getDateKey(date);

      final ml = widget.drinkMlByDate[key] ?? 0;
      final value = ml / targetMl;

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


}

class _BottlePainter extends CustomPainter {
  final double progress;

  _BottlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final bottleRect = Rect.fromLTWH(
      size.width * 0.22,
      size.height * 0.05,
      size.width * 0.56,
      size.height * 0.9,
    );

    final bottle = RRect.fromRectAndRadius(
      bottleRect,
      const Radius.circular(32),
    );

    final bgPaint = Paint()
      ..color = const Color(0xFFEFFBFF)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;

    canvas.drawRRect(bottle, bgPaint);

    final waterTop = bottleRect.bottom - bottleRect.height * progress;

    final waterRect = Rect.fromLTWH(
      bottleRect.left + 4,
      waterTop,
      bottleRect.width - 8,
      bottleRect.bottom - waterTop - 4,
    );

    final waterPath = Path()
      ..moveTo(waterRect.left, waterRect.top + 10)
      ..quadraticBezierTo(
        waterRect.left + waterRect.width / 2,
        waterRect.top - 8,
        waterRect.right,
        waterRect.top + 10,
      )
      ..lineTo(waterRect.right, waterRect.bottom)
      ..lineTo(waterRect.left, waterRect.bottom)
      ..close();

    final waterPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF81D4FA),
          Color(0xFF29B6F6),
        ],
      ).createShader(waterRect);

    canvas.drawPath(waterPath, waterPaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          bottleRect.left + bottleRect.width * 0.18,
          bottleRect.top + 18,
          bottleRect.width * 0.12,
          bottleRect.height * 0.55,
        ),
        const Radius.circular(20),
      ),
      highlightPaint,
    );

  }

  @override
  bool shouldRepaint(covariant _BottlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }


}