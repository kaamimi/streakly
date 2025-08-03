import 'dart:convert';
import 'package:http/http.dart' as http;

class LeetCodeAPI {
  LeetCodeAPI({required this.username});

  final String username;
  static const Map<String, int> _difficultyOrder = {
    "All": 0,
    "Easy": 1,
    "Medium": 2,
    "Hard": 3,
  };

  // Fetch LeetCode stats
  Future<Map<String, dynamic>> _fetchUserData() async {
    final String query = '''
    {
      matchedUser(username: "$username") {
        username
        submitStats: submitStatsGlobal {
          acSubmissionNum {
            difficulty
            count
            submissions
          }
        }
      }
    }
    ''';

    final response = await http.post(
      Uri.parse("https://leetcode.com/graphql"),
      headers: {
        "Content-Type": "application/json",
        "Referer": "https://leetcode.com",
        "Origin": "https://leetcode.com",
      },
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Validate JSON structure
      if (jsonData.containsKey("data") &&
          jsonData["data"] != null &&
          jsonData["data"].containsKey("matchedUser") &&
          jsonData["data"]["matchedUser"] != null) {
        return jsonData;
      } else {
        throw Exception("User not found or invalid response format.");
      }
    }
    throw Exception("Failed to fetch data: ${response.statusCode}");
  }

  // Get the number of questions solved for a specific difficulty
  Future<int> getDifficultyCount(String difficulty) async {
    if (!_difficultyOrder.containsKey(difficulty)) {
      throw ArgumentError(
        "Invalid difficulty: $difficulty. Expected one of ${_difficultyOrder.keys}",
      );
    }

    final data = await _fetchUserData();
    final submissions =
        data["data"]["matchedUser"]["submitStats"]["acSubmissionNum"];

    if (submissions == null) {
      throw Exception("Invalid API response structure or missing data.");
    }

    final index = _difficultyOrder[difficulty]!;
    if (submissions.length > index) {
      return submissions[index]["count"] as int;
    }

    throw Exception("No data available for difficulty: $difficulty");
  }
}
