import 'package:flutter/material.dart';
import 'drink_detail_page.dart';

class DrinkTaskCard extends StatelessWidget {
  final String title;
  final DateTime selectedDate;
  final Map<String, int> drinkMlByDate;
  final Map<String, String> drinkFeelByDate;
  final VoidCallback onDrinkChanged;

  const DrinkTaskCard({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.drinkMlByDate,
    required this.drinkFeelByDate,
    required this.onDrinkChanged,
  });

  String getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = getDateKey(selectedDate);
    final ml = drinkMlByDate[dateKey] ?? 0;
    final completed = ml > 0;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DrinkDetailPage(
              initialMl: ml,
              selectedDate: selectedDate,
              drinkMlByDate: drinkMlByDate,
            ),
          ),
        );

        if (result != null) {
          drinkMlByDate[dateKey] = result;
          onDrinkChanged();
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

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: completed
                      ? const Color(0xFF7C74F8)
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            if (ml > 0) ...[
              Text(
                "$ml ml",
                style: const TextStyle(
                  color: Color(0xFF7C74F8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ],
        ),
      ),
    );
  }
}

