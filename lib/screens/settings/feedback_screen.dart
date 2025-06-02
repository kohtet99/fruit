import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  FeedbackScreen({super.key});

  final Color _primaryColor = const Color(0xFF58211B);
  final Color _secondaryColor = const Color(0xFF854442);

  Future<void> _launchGmail(BuildContext context) async {
    final body = Uri.encodeComponent(_controller.text.trim());
    final subject = Uri.encodeComponent("App Feedback");
    final recipient = 'lufi9492@gmail.com';

    final mailtoUri = Uri.parse('mailto:$recipient?subject=$subject&body=$body');
    final gmailWebUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$recipient&su=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(gmailWebUri)) {
        await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No email or browser available';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open Gmail. Please send manually to: lufi9492@gmail.com',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text('Feedback', style: TextStyle(color: Colors.white, fontSize: 16),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.feedback_outlined, size: 64, color: Color(0xFF58211B)),
                      const SizedBox(height: 16),
                      const Text(
                        'Share Your Feedback',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF58211B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Let us know what you think or if you encountered any issues.',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _controller,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Your Message',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _launchGmail(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          'Send via Gmail',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF58211B), fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
