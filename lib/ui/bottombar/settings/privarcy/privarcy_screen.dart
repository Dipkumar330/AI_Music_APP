import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Privacy Policy')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9B57FF), // top-left
              Color(0xFF6D4AFF), // bottom-right
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            40.sizeBoxH,
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            Expanded(
              child: const SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Text('''
Privacy Policy

Welcome to AI Music APP! This Privacy Policy explains how we collect, use, and protect your information when you use our AI-powered music app.

1. Information We Collect
We may collect the following types of data:
- Personal Information (e.g., name, email) — only if provided voluntarily.
- Usage Data (e.g., interactions with the app, selected moods, genres).
- Device Information (e.g., device type, OS version).

2. How We Use Your Information
We use your information to:
- Generate personalized music, lyrics, and playlists.
- Improve app functionality and user experience.
- Send important updates or promotional materials (if you opt in).

3. Data Sharing
We do not sell or rent your personal data. We may share data:
- With trusted third-party services (e.g., AI APIs, Spotify SDK) strictly for functionality.
- When required by law.

4. Data Security
We implement appropriate measures to protect your data. However, no method is 100% secure.

5. Your Choices
You can:
- Request deletion of your data.
- Opt out of analytics and promotional emails.

6. Children’s Privacy
Our app is not intended for children under 13. We do not knowingly collect data from minors.

7. Changes to This Policy
We may update this policy. Changes will be posted in the app with a revised "Effective Date".

          ''', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
