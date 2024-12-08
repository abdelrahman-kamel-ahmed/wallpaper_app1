import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.black),
              title: const Text(
                "Push notifications",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              trailing: Switch(
                value: pushNotifications,
                onChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                  });
                },
              ),
            ),
            const Divider(),
            buildSettingsOption(
              icon: Icons.person_add,
              title: 'Invite a friend',
              onTap: () {},
            ),
            buildSettingsOption(
              icon: Icons.star_rate,
              title: 'Rate this app',
              onTap: () {},
            ),
            buildSettingsOption(
              icon: Icons.feedback,
              title: 'Feedback & bugs',
              onTap: () {},
            ),
            buildSettingsOption(
              icon: Icons.description,
              title: 'Terms & Conditions',
              onTap: () {},
            ),
            buildSettingsOption(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
