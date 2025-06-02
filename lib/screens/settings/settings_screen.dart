import 'package:assignment1/screens/auth/forgetpassword_screen.dart';
import 'package:assignment1/screens/settings/about_screen.dart';
import 'package:assignment1/screens/settings/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment1/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final authProvider = context.watch<AuthProvider>();
    final userEmail = authProvider.user?.email ?? 'No email';

    final bgColor = Colors.white;
    final sectionColor = Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor:  Color(0xFF58211B),
        elevation: 0,
        iconTheme: IconThemeData(color: bgColor),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: bgColor, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(userEmail),
          const SizedBox(height: 20),
          _buildSection("Other settings", [
            _buildTile(Icons.lock_outline, "Forget Password", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
              );
            }),
          ], sectionColor),
          const SizedBox(height: 20),
          _buildSection("", [
            _buildTile(Icons.info_outline, "About application", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AboutScreen()),
              );
            }),
            _buildTile(Icons.feedback, "Feedback", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FeedbackScreen()),
              );
            }),
            _buildTile(Icons.logout, "Logout", () {
              _confirmLogout(context, auth);
            }, isDestructive: true),
          ], sectionColor),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String email) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/logo/avatar.jpg'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Customer",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, Color? bg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 48, color: Color(0xFF58211B)),
                const SizedBox(height: 16),
                const Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58211B),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF58211B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFF58211B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF58211B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
      await auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }
}
