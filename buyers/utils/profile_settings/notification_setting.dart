import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _newMessages = true;
  bool _newFollowers = true;
  bool _mentions = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('New Messages'),
            value: _newMessages,
            onChanged: (bool value) {
              setState(() {
                _newMessages = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('New Followers'),
            value: _newFollowers,
            onChanged: (bool value) {
              setState(() {
                _newFollowers = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Mentions'),
            value: _mentions,
            onChanged: (bool value) {
              setState(() {
                _mentions = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('App Updates'),
            value: _appUpdates,
            onChanged: (bool value) {
              setState(() {
                _appUpdates = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // Save the settings to the backend or local storage
    print('New Messages: $_newMessages');
    print('New Followers: $_newFollowers');
    print('Mentions: $_mentions');
    print('App Updates: $_appUpdates');
  }
}
