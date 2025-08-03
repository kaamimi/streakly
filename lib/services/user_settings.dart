import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  final SharedPreferences prefs;

  UserSettings._(this.prefs);

  static Future<UserSettings> accessPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return UserSettings._(prefs);
  }

  // Push Notifications
  bool get pushNotif {
    final bool? isPushNotif = prefs.getBool('pushNotifications');
    return isPushNotif ?? false;
  }

  void toggleNotifs() {
    final curr = pushNotif;
    prefs.setBool('pushNotifications', !curr);
  }

  // Notification Frequency
  String get notifFrequency {
    final String? freq = prefs.getString('notificationFrequency');
    return freq ?? 'Daily'; // default to 'Daily' if not set
  }

  void setNotifFrequency(String frequency) {
    prefs.setString('notificationFrequency', frequency);
  }
}
