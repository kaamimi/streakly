import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streakly/providers/codeforces_provider.dart';

// String capitalization extension
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class CodeforcesCard extends ConsumerWidget {
  const CodeforcesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Codeforces",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildValueCard(context, ref, "rating")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildValueCard(context, ref, "rank")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(BuildContext context, WidgetRef ref, String label) {
    final data = ref.watch(cfFutureProvider(label));

    const Color baseColor = Color(0xFF1F8ACB);
    final Color backgroundColor = baseColor.withAlpha(20);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: baseColor.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label.capitalize(),
            style: textTheme.titleMedium?.copyWith(
              color: baseColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          data.when(
            data:
                (value) => Text(
                  value ?? "-",
                  style: textTheme.titleLarge?.copyWith(
                    color: baseColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            loading:
                () => const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                  ),
                ),
            error:
                (err, _) => const Text(
                  'Error',
                  style: TextStyle(color: Colors.redAccent),
                ),
          ),
        ],
      ),
    );
  }
}
