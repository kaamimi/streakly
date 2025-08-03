import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streakly/services/leetcode_api.dart';
import 'package:streakly/services/user_info.dart';

final lcProvider = FutureProvider<LeetCodeAPI>((ref) async {
  final userInfo = await UserInfo.accessPrefs();
  final username = userInfo.getLCUser;
  return LeetCodeAPI(username: username);
});

final lcFutureProvider = FutureProvider.family<int, String>((
  ref,
  difficulty,
) async {
  final api = await ref.watch(lcProvider.future);
  return api.getDifficultyCount(difficulty);
});

final lcRefreshProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(lcProvider);
    ref.invalidate(lcFutureProvider('Easy'));
    ref.invalidate(lcFutureProvider('Medium'));
    ref.invalidate(lcFutureProvider('Hard'));
  };
});
