import 'dart:convert';
import 'package:http/http.dart' as http;

class CodeforcesAPI {
  const CodeforcesAPI({required this.username});
  final String username;

  Future<Map<String, dynamic>> _fetchUserData() async {
    final url = Uri.parse(
      "https://codeforces.com/api/user.info?handles=$username",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'][0];
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  Future<String> getData(String key) async {
    final data = await _fetchUserData();
    return data[key].toString();
  }
}
