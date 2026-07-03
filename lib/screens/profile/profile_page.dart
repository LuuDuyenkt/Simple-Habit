import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_personal_info_page.dart';
import 'dart:io';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String birthday = "04/01/2004";
  String motivation = "Trying to become better every day";
  String startedOn = "Apr 21, 2026";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? const Color(0xFF0F0F14) : const Color(0xFFF7F4FA);

    final cardColor =
    isDark ? const Color(0xFF23232A) : Colors.white;

    final primaryText =
    isDark ? Colors.white : const Color(0xFF1E1A22);

    final secondaryText =
    isDark ? Colors.white70 : const Color(0xFF7A7483);

    final borderColor =
    isDark ? Colors.white12 : const Color(0xFFE6DFF0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: primaryText),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFF6C63FF),
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.person, size: 45, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 10),

              // Name
              Text(
                "Luu Duyen",
                style: TextStyle(
                  color: primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Edit row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPersonalInfoPage(
                            currentBirthday: birthday,
                            currentMotivation: motivation,
                            currentStartedOn: startedOn,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          birthday = result['birthday'] ?? birthday;
                          motivation = result['motivation'] ?? motivation;
                          startedOn = result['startedOn'] ?? startedOn;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            color: secondaryText, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          "Edit Personal Info",
                          style: TextStyle(color: secondaryText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: secondaryText, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          "Edit Photo",
                          style: TextStyle(color: secondaryText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Personal Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personal Info",
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Birthday
                    Text("Birthday",
                        style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 4),
                    Text(birthday,
                        style: TextStyle(color: primaryText)),

                    const SizedBox(height: 12),

                    // Started on
                    Text("Started on",
                        style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 4),
                    Text(startedOn,
                        style: TextStyle(color: primaryText)),

                    const SizedBox(height: 12),

                    // Motivation
                    Text("Motivation",
                        style: TextStyle(color: secondaryText)),
                    const SizedBox(height: 4),
                    Text(
                      motivation,
                      style: TextStyle(
                        color: secondaryText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Photo section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Memory Photo",
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2B2B33)
                              : const Color(0xFFF2EEF7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor
                          ),
                        ),
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 34,
                              color: secondaryText,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tap to add photo",
                              style: TextStyle(
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}