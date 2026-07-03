import 'package:flutter/material.dart';
import 'dart:math';



class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final VoidCallback onStart;
  final Map<String, int> walkStepsByDate;


  // const HomePage({super.key, required this.tasks});
  HomePage({
    super.key,
    required this.tasks,
    required this.onStart,
    required this.walkStepsByDate,
  });

  final List<String> quotes = [
    "Because you are capable of overcoming it, this challenge appears.",
    "Starting is better than waiting. Patience is better than ego.",
    "Winning over yourself is the hardest\nbut most important victory.",
    "Fall seven times, stand up eight. Never give up.",
    "Don’t think you can’t do it. You can. You must. You will find a way.",
    "Failure is the mother of success.",
    "Learn, learn more, learn forever.",
    "You are stronger than you think.",
    "Do it, even when it’s hard.",
    "Your effort today will thank you tomorrow.",
    "One small step today is one big step tomorrow.",
  ];

  @override
  Widget build(BuildContext context) {
    const mainPurple = Color(0xFF7C74F8);
    const lightPurple = Color(0xFF9A94FF);

    final now = DateTime.now();
    final walkStreak = calculateWalkStreak(walkStepsByDate);
    final List<String> weekDays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final List<String> months = [
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

    final String formattedDate =
        '${weekDays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
    final int dayIndex = now.day % quotes.length;
    final String todayQuote = quotes[dayIndex];

    // print (now);
    // print(dayIndex);
    // print(todayQuote);
     // thoát app , chỉnh ngày setting, vào lại chạy flutter run

    // final completed = tasks.where((task) => task['done'] == true).length;

    String getDateKey(DateTime date) {
      return "${date.year}-${date.month}-${date.day}";
    }

    final todayKey = getDateKey(DateTime.now());


    //final completed = tasks.where((task) => task['done'] == true).length;
    double completed = 0;

    for (var task in tasks) {
      final title = task['title'].toString().toLowerCase();

      if (title.contains('walk')) {
        final steps = task['steps'] ?? 0;
        completed += steps / 8000;
      } else if (title.contains('drink')) {
        final ml = task['ml'] ?? 0;
        completed += ml / 1500;
      } else {
        if (task['done'] == true) {
          completed += 1;
        }
      }
    }

    final completedCount = tasks.where((task) => task['done'] == true).length;

    final total = tasks.length;
    String reviewText;

    if (total == 0) {
      reviewText = "Start your journey today 🚀";
    } else if (completed == total) {
      reviewText = "Perfect day! Keep it up 🔥";
    } else if (completed > total / 2) {
      reviewText = "Good job! You're doing well 💪";
    } else if (completed > 0) {
      reviewText = "Keep going, don’t stop now ✨";
    } else {
      reviewText = "Let’s start small today 🌱";
    }

    final progress = total == 0 ? 0.0 : completed / total;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// BOTTom

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // const Text(
              //   'Sun, 4 February 2026',
              //   style: TextStyle(fontSize: 14, color: Colors.black54),
              // ),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hello, ',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    TextSpan(
                      text: 'Luu Duyen!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: mainPurple,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// CARD 1
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [mainPurple, lightPurple],
                  ),
                ),
                child:  Text(
                  todayQuote,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                // Text(
                //   'Winning over yourself is the hardest\nbut most important victory.',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 15,
                //     height: 1.4,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ),



              const SizedBox(height: 20),

              /// CARD 2 (PROGRESS)
              Stack(
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 170),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [mainPurple, lightPurple],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Progress",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),


                        Row(
                          children: [
                            _ProgressCircle(
                              progress: progress.clamp(0.0, 1.0),
                              text: "${(progress * 100).round()}%",
                            ),

                            const SizedBox(width: 24),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$completedCount of $total habits\ncompleted today!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      height: 1.35,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    reviewText,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ICON LỊCH
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.white.withOpacity(0.6),
                      size: 28,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Start Today →',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),


                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

/// PROGRESS RING (đẹp, giống Figma hơn)
class _ProgressCircle extends StatelessWidget {
  final double progress;
  final String text;

  const _ProgressCircle({
    required this.progress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(104, 104),
      painter: _RingPainter(progress),
      child: SizedBox(
        width: 104,
        height: 104,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

String getDateKey(DateTime date) {
  return "${date.year}-${date.month}-${date.day}";
}

int calculateWalkStreak(Map<String, int> walkStepsByDate) {
  int streak = 0;
  DateTime current = DateTime.now();

  while (true) {
    final key = getDateKey(current);
    final steps = walkStepsByDate[key] ?? 0;

    if (steps >= 8000) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
}
