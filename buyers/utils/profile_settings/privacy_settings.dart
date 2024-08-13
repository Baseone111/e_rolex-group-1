import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _profileVisible = true;
  bool _dataSharingEnabled = false;
  bool _adPersonalizationEnabled = true;
  bool _activityStatusVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Profile Visibility'),
            subtitle: const Text('Allow others to see your profile'),
            value: _profileVisible,
            onChanged: (bool value) {
              setState(() {
                _profileVisible = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Data Sharing'),
            subtitle: const Text('Share data with third-party partners'),
            value: _dataSharingEnabled,
            onChanged: (bool value) {
              setState(() {
                _dataSharingEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Ad Personalization'),
            subtitle: const Text('Receive personalized ads based on your activity'),
            value: _adPersonalizationEnabled,
            onChanged: (bool value) {
              setState(() {
                _adPersonalizationEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Activity Status'),
            subtitle: const Text('Show your activity status to others'),
            value: _activityStatusVisible,
            onChanged: (bool value) {
              setState(() {
                _activityStatusVisible = value;
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
    print('Profile Visibility: $_profileVisible');
    print('Data Sharing: $_dataSharingEnabled');
    print('Ad Personalization: $_adPersonalizationEnabled');
    print('Activity Status: $_activityStatusVisible');
  }
}
