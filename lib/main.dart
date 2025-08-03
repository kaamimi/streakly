import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:streakly/screens/home.dart';
import 'package:streakly/screens/onboarding.dart';

void main() => runApp(ProviderScope(child: Streakly()));

final ThemeData _themeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF1E1E1E),
  scaffoldBackgroundColor: Color(0xFF161616),
  cardColor: Color(0xFF222222),
  canvasColor: Color(0xFF1E1E1E),
  dividerColor: Color(0xFF2C2C2C),

  textTheme: TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontSize: 32),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 18),
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
    bodySmall: TextStyle(color: Color(0xFF808080), fontSize: 12),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF161616),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
);

class Streakly extends StatefulWidget {
  const Streakly({super.key});

  @override
  State<Streakly> createState() => _StreaklyState();
}

class _StreaklyState extends State<Streakly> {
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkUsernames();
  }

  Future<void> _checkUsernames() async {
    final prefs = await SharedPreferences.getInstance();
    final lcUser = prefs.getString('lcUser');
    final cfUser = prefs.getString('cfUser');

    setState(() {
      if (lcUser != null &&
          lcUser.isNotEmpty &&
          cfUser != null &&
          cfUser.isNotEmpty) {
        _initialScreen = const HomePage();
      } else {
        _initialScreen = OnboardingPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streakly',
      theme: _themeData,
      home:
          _initialScreen ??
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
