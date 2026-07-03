import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final mainTextColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final labelColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
    final hintColor = isDark ? Colors.white54 : Colors.grey.shade500;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: mainTextColor),
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Create your account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start building better habits today.',
              style: TextStyle(
                fontSize: 16,
                color: subTextColor,
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Name',
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              style: TextStyle(color: mainTextColor),
              cursorColor: const Color(0xFF6C63FF),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: TextStyle(color: hintColor),
                filled: true,
                fillColor: cardColor,
                prefixIcon: Icon(Icons.person_outline, color: iconColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Email',
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              style: TextStyle(color: mainTextColor),
              cursorColor: const Color(0xFF6C63FF),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: hintColor),
                filled: true,
                fillColor: cardColor,
                prefixIcon: Icon(Icons.email_outlined, color: iconColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Password',
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: TextStyle(color: mainTextColor),
              cursorColor: const Color(0xFF6C63FF),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: hintColor),
                filled: true,
                fillColor: cardColor,
                prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _input(String hint, IconData icon, [bool isPassword = false]) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}