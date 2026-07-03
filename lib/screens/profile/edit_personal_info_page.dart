import 'package:flutter/material.dart';

class EditPersonalInfoPage extends StatefulWidget {
  final String currentBirthday;
  final String currentMotivation;
  final String currentStartedOn;

  const EditPersonalInfoPage({
    super.key,
    required this.currentBirthday,
    required this.currentMotivation,
    required this.currentStartedOn,
  });

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  late TextEditingController motivationController;
  DateTime? selectedDate;
  DateTime? selectedStartedOn;

  @override
  void initState() {
    super.initState();
    motivationController = TextEditingController(text: widget.currentMotivation);

    if (widget.currentBirthday.isNotEmpty) {
      try {
        final parts = widget.currentBirthday.split('/');
        if (parts.length == 3) {
          selectedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    if (widget.currentStartedOn.isNotEmpty) {
      try {
        final parts = widget.currentStartedOn.split('/');
        if (parts.length == 3) {
          selectedStartedOn = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

  }

  @override
  void dispose() {
    motivationController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2004, 1, 4),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickStartedOnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartedOn ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedStartedOn = picked;
      });
    }
  }

  void setSuggestion(String text) {
    setState(() {
      motivationController.text = text;
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? const Color(0xFF0F0F14) : const Color(0xFFF7F4FA);
    final cardColor =
    isDark ? const Color(0xFF23232A) : Colors.white;
    final inputColor =
    isDark ? const Color(0xFF1E1E24) : Colors.white;
    final primaryText =
    isDark ? Colors.white : const Color(0xFF1E1A22);
    final secondaryText =
    isDark ? Colors.white70 : const Color(0xFF7A7483);
    final borderColor =
    isDark ? Colors.white12 : const Color(0xFFE6DFF0);
    final chipBg =
    isDark ? const Color(0xFF2B2738) : const Color(0xFFE9E4FF);
    final chipText =
    isDark ? Colors.white : const Color(0xFF5E56D6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Edit Personal Info",
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Birthday",
              style: TextStyle(
                color: secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  selectedDate == null ? "Select date" : formatDate(selectedDate),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Started on",
              style: TextStyle(
                color: secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickStartedOnDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  selectedStartedOn == null
                      ? "Select date"
                      : formatDate(selectedStartedOn),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              "Motivation",
              style: TextStyle(
                color: secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: motivationController,
              style: TextStyle(
                color: primaryText,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "Write your motivation",
                hintStyle: TextStyle(color: secondaryText),
                filled: true,
                fillColor: inputColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF7C74F8),
                    width: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildSuggestionChip(
                  text: "Small steps every day",
                  bgColor: chipBg,
                  textColor: chipText,
                  onTap: () => setSuggestion("Small steps every day"),
                ),
                _buildSuggestionChip(
                  text: "Stay consistent",
                  bgColor: chipBg,
                  textColor: chipText,
                  onTap: () => setSuggestion("Stay consistent"),
                ),
                _buildSuggestionChip(
                  text: "1% better every day",
                  bgColor: chipBg,
                  textColor: chipText,
                  onTap: () => setSuggestion("1% better every day"),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'birthday': formatDate(selectedDate),
                          'startedOn': formatDate(selectedStartedOn),
                          'motivation': motivationController.text.trim(),
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip({
    required String text,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
//
// class EditPersonalInfoPage extends StatefulWidget {
//   const EditPersonalInfoPage({super.key});
//
//   @override
//   State<EditPersonalInfoPage> createState() =>
//       _EditPersonalInfoPageState();
// }
//
// class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
//   final TextEditingController motivationController =
//   TextEditingController();
//
//   DateTime? selectedDate;
//
//   Future<void> pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2004, 1, 4),
//       firstDate: DateTime(1990),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   void setSuggestion(String text) {
//     motivationController.text = text;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final bgColor = isDark ? const Color(0xFF0F0F14): const Color(0xFFF7F4FA);
//
//     final cardColor =
//     isDark ? const Color(0xFF23232A) : Colors.white;
//
//     final inputColor =
//     isDark ? const Color(0xFF1E1E24) : Colors.white;
//
//     final primaryText =
//     isDark ? Colors.white : const Color(0xFF1E1A22);
//
//     final secondaryText =
//     isDark ? Colors.white70 : Colors.black54;
//
//     final borderColor =
//     isDark ? Colors.white12 : Colors.black12;
//
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         title: Text(
//           "Edit Personal Info",
//           style: TextStyle(color: primaryText),
//         ),
//         backgroundColor: bgColor,
//         elevation: 0,
//         iconTheme: IconThemeData(color: primaryText),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Birthday
//             Text(
//               "Birthday",
//               style: TextStyle(color: secondaryText),
//             ),
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: pickDate,
//               child: Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   selectedDate == null
//                       ? "Select date"
//                       : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                   style: TextStyle(color:primaryText),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             Text(
//               "Motivation",
//               style: TextStyle(color: secondaryText),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               style: TextStyle(color: primaryText),
//               decoration: InputDecoration(
//                 hintText: "Small steps every day ✨",
//                 hintStyle: TextStyle(color: secondaryText),
//                 filled: true,
//                 fillColor: inputColor,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: borderColor),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             // Suggestions
//             Wrap(
//               spacing: 10,
//               children: [
//                 suggestionChip("Small steps every day"),
//                 suggestionChip("Stay consistent"),
//                 suggestionChip("1% better every day"),
//               ],
//             ),
//
//             const Spacer(),
//
//             // Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Cancel"),
//                   ),
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Save"),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget suggestionChip(String text) {
//     return GestureDetector(
//       onTap: () => setSuggestion(text),
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//             horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.grey[800],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
