import 'package:ai_music/utils/size_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Help & Support')),
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
Help & Support

Welcome to the Help & Support Center of AI Music APP!

We’re here to assist you with any questions, issues, or feedback you may have while using our AI music app.

1. Common Questions

Q: How do I generate a song or playlist?
A: Choose your mood, genre, and preferences on the home screen, then tap "Generate."

Q: Can I save my favorite tracks?
A: Yes! Tap the heart icon next to any generated content to save it to your favorites.

Q: Do I need an internet connection?
A: Yes, the app requires internet access to use AI services and stream music.

2. Troubleshooting

- App not working? Try restarting the app or checking your internet connection.
- Can't log in? Ensure your credentials are correct and your internet is stable.
- Music not generating? Check that your input selections are complete and valid.

3. Contact Support

If your issue isn’t listed or you need personal assistance, contact us:
- 📧 Email: [support@aimusic.com]
- 🌐 Website: [https://aimusic.com/support]
- 💬 In-App Chat: [Coming soon / available in Settings]

4. Feedback & Suggestions

We’re constantly improving! Feel free to share feedback or suggest new features.

Thank you for using AI Music APP 🎵
          ''', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
