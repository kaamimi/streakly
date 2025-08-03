import 'package:flutter/material.dart';
import 'package:streakly/services/user_settings.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  late UserSettings _settings;
  bool _togglePush = false;
  String _selected = 'Daily';

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  void _initSettings() async {
    _settings = await UserSettings.accessPrefs();
    if (!mounted) return;
    setState(() {
      _togglePush = _settings.pushNotif;
      _selected = _settings.notifFrequency;
    });
  }

  void _onToggleChanged(bool value) {
    _settings.toggleNotifs();
    setState(() {
      _togglePush = value;
    });
  }

  void _onRadioChanged(String? value) {
    if (value == null) return;
    _settings.setNotifFrequency(value);
    setState(() {
      _selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Reminders', style: textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: const Color.fromARGB(255, 76, 175, 79),
                  activeTrackColor: const Color.fromARGB(80, 76, 175, 79),
                  title: const Text('Push Notifications'),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  value: _togglePush,
                  onChanged: _onToggleChanged,
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Frequency',
                        style: textTheme.titleMedium,
                      ),
                      ...['Daily', 'Weekly'].map(
                        (option) => RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selected,
                          onChanged: _onRadioChanged,
                          activeColor: const Color.fromARGB(255, 76, 175, 79),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
