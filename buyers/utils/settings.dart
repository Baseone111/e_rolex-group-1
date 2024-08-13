
import 'package:flutter/material.dart';
import 'package:new_erolex_app/views/buyers/utils/profile_settings/account_settings.dart';
import 'package:new_erolex_app/views/buyers/utils/profile_settings/notification_setting.dart';
import 'package:new_erolex_app/views/buyers/utils/profile_settings/privacy_settings.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.yellow.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSettingsPage()));
              // Navigate to account settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsPage(),
                  )); // Navigate to notifications settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySettingsPage(),
                  )); // Navigate to privacy settings
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
