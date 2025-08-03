import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  final SharedPreferences prefs;

  UserInfo._(this.prefs);

  static Future<UserInfo> accessPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return UserInfo._(prefs);
  }

  // LeetCode
  String get getLCUser {
    final String? username = prefs.getString('lcUser');
    return username ?? 'kaamimi';
  }

  Future<void> setLCUser(String username) async {
    await prefs.setString('lcUser', username);
  }

  // Codeforces
  String get getCFUser {
    final String? username = prefs.getString('cfUser');
    return username ?? 'Rup_z';
  }

  Future<void> setCFUser(String username) async {
    await prefs.setString('cfUser', username);
  }
}

// Check if LeetCode and Codeforces usernames already exists in SharedPreferences
Future<Map<String, bool>> checkUserExists() async {
  final userInfo = await UserInfo.accessPrefs();
  final isLCUser = userInfo.getLCUser.isNotEmpty;
  final isCFUser = userInfo.getCFUser.isNotEmpty;
  return {'isLCUser': isLCUser, 'isCFUser': isCFUser};
}
