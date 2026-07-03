import 'package:flutter/material.dart';
import 'walk_detail_page.dart';

class WalkTaskCard extends StatefulWidget {
  final Map<String, int> walkStepsByDate;
  final Map<String, String> walkFeelByDate;
  final String title;

  final DateTime selectedDate;
  final VoidCallback onWalkChanged;

  const WalkTaskCard({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.walkStepsByDate,
    required  this.onWalkChanged,
    required this.walkFeelByDate,
  });

  @override
  State<WalkTaskCard> createState() => _WalkTaskCardState();
}

class _WalkTaskCardState extends State<WalkTaskCard> {
  //int steps = 0;
  final int targetSteps = 8000;

  @override
  Widget build(BuildContext context) {
    final dateKey =
        "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";
    final feel = widget.walkFeelByDate[dateKey] ?? '';
    final steps = widget.walkStepsByDate[dateKey] ?? 0;
    final completed = steps > 0;
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WalkDetailPage(
              initialSteps: steps,
              targetSteps: targetSteps,
              initialFeel: feel,
              selectedDate: widget.selectedDate,
              walkStepsByDate: widget.walkStepsByDate,
            ),
          ),
        );

        if (result != null) {
          setState(() {
            widget.walkStepsByDate[dateKey] = result['steps'] ?? steps;
            widget.walkFeelByDate[dateKey] = result['feel'] ?? feel;
          });
          widget.onWalkChanged();

        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: completed
              ? const Color(0xFFEDEBFF)
              : Theme.of(context).cardColor,
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
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed
                  ? const Color(0xFF7C74F8)
                  : Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.directions_walk,
              color: Color(0xFF7C74F8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: completed
                      ? const Color(0xFF7C74F8)
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (steps > 0)
              Text(
                '$steps steps',
                style: const TextStyle(
                  color: Color(0xFF7C74F8),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
