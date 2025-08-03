import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streakly/services/codeforces_api.dart';
import 'package:streakly/services/user_info.dart';

final cfUserProvider = FutureProvider<String>((ref) async {
  final userInfo = await UserInfo.accessPrefs();
  return userInfo.getCFUser;
});

final cfFutureProvider = FutureProvider.family<String?, String>((
  ref,
  key,
) async {
  final cfUser = await ref.watch(cfUserProvider.future);
  if (cfUser != '') {
    final api = CodeforcesAPI(username: cfUser);
    return await api.getData(key);
  } else {
    return null;
  }
});

final cfRefreshProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(cfFutureProvider);
  };
});
