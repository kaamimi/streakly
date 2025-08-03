import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streakly/services/user_info.dart';

import 'package:streakly/widgets/add_card.dart';
import 'package:streakly/widgets/codeforces_card.dart';
import 'package:streakly/widgets/leetcode_card.dart';

final cardVisibilityProvider = FutureProvider<Map<String, bool>>((ref) async {
  return await checkUserExists();
});

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardVisibilityAsyncValue = ref.watch(cardVisibilityProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            cardVisibilityAsyncValue.when(
              data: (visibilityMap) {
                final isLCUser = visibilityMap['isLCUser']!;
                final isCFUser = visibilityMap['isCFUser']!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLCUser) const LeetCodeCard(),
                    const SizedBox(height: 8),
                    if (isCFUser) const CodeforcesCard(),
                    const SizedBox(height: 8),
                    // if ((isLCUser && !isCFUser) || (!isLCUser && isCFUser))
                    const AddCard(),
                  ],
                );
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    'Failed to load card visibility. Error: ${error.toString()}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
