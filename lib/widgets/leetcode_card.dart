import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:streakly/providers/leetcode_provider.dart';

final difficultyColors = {
  "Easy": Colors.green,
  "Medium": Colors.orange,
  "Hard": Colors.red,
};

class LeetCodeCard extends ConsumerStatefulWidget {
  const LeetCodeCard({super.key});

  @override
  ConsumerState<LeetCodeCard> createState() => _LeetCodeCardState();
}

class _LeetCodeCardState extends ConsumerState<LeetCodeCard>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final easy = ref.watch(lcFutureProvider("Easy"));
    final medium = ref.watch(lcFutureProvider("Medium"));
    final hard = ref.watch(lcFutureProvider("Hard"));

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => setState(() => expanded = !expanded),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LeetCode",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.expand_more),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Difficulty Stats
                Row(
                  children: const [
                    Expanded(child: _DifficultyColumn(difficulty: "Easy")),
                    SizedBox(width: 8),
                    Expanded(child: _DifficultyColumn(difficulty: "Medium")),
                    SizedBox(width: 8),
                    Expanded(child: _DifficultyColumn(difficulty: "Hard")),
                  ],
                ),
                // Expanded Pie Chart
                if (expanded) ...[
                  const SizedBox(height: 24),
                  _LeetCodePieChart(easy, medium, hard),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyColumn extends ConsumerWidget {
  final String difficulty;

  const _DifficultyColumn({required this.difficulty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(lcFutureProvider(difficulty));

    final baseColor = difficultyColors[difficulty] ?? Colors.grey;
    final bgColor = baseColor.withAlpha(25);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: baseColor.withAlpha(40),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            difficulty,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: baseColor,
            ),
          ),
          const SizedBox(height: 6),
          count.when(
            data:
                (value) => Text(
                  value.toString(),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                  ),
                ),
            loading:
                () => SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                  ),
                ),
            error:
                (err, _) => const Text(
                  "Error",
                  style: TextStyle(color: Colors.redAccent),
                ),
          ),
        ],
      ),
    );
  }
}

class _LeetCodePieChart extends StatelessWidget {
  final AsyncValue<int> easy;
  final AsyncValue<int> medium;
  final AsyncValue<int> hard;

  const _LeetCodePieChart(this.easy, this.medium, this.hard);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildChart(int easyCount, int mediumCount, int hardCount) {
      final total = easyCount + mediumCount + hardCount;

      final data = {
        "Easy": easyCount,
        "Medium": mediumCount,
        "Hard": hardCount,
      };

      List<PieChartSectionData> getSections(double radius) {
        return data.entries.map((entry) {
          final percent = (entry.value / total) * 100;
          final color = difficultyColors[entry.key]!;

          return PieChartSectionData(
            value: percent,
            color: color,
            title: "${percent.round()}%",
            radius: radius,
            titleStyle: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final radius = constraints.maxWidth / 2.5;

          return SizedBox(
            height: radius * 2.1,
            child: PieChart(
              PieChartData(
                sections: getSections(radius),
                centerSpaceRadius: 8,
                sectionsSpace: 2,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
              ),
            ),
          );
        },
      );
    }

    return easy.when(
      data:
          (e) => medium.when(
            data:
                (m) => hard.when(
                  data: (h) => buildChart(e, m, h),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
