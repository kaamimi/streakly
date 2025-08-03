import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:streakly/providers/codeforces_provider.dart';
import 'package:streakly/providers/leetcode_provider.dart';
import 'package:streakly/screens/overview.dart';
import 'package:streakly/screens/reminders.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController();
  final List<Color> _indicatorColors = [
    const Color.fromARGB(150, 13, 154, 255),
    const Color.fromARGB(150, 76, 175, 79),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final refreshLeetCode = ref.watch(lcRefreshProvider);
    final refreshCodeforces = ref.watch(cfRefreshProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Streakly",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: const [OverviewPage(), RemindersPage()],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500),
          ),
          height: 70,
        ),
        child: NavigationBar(
          indicatorColor: _indicatorColors[_selectedIndex],
          backgroundColor: const Color(0xFF161616),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: "Overview",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: "Reminders",
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),

      floatingActionButton:
          (_selectedIndex == 0)
              ? FloatingActionButton.extended(
                onPressed: () async {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data refreshed')),
                  );
                  await refreshLeetCode();
                  await refreshCodeforces();
                },
                label: const Text("Refresh"),
                icon: const Icon(Icons.refresh_outlined),
                backgroundColor: const Color.fromARGB(150, 13, 154, 255),
                tooltip: 'Refresh data',
              )
              : null,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
