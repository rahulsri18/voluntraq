import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/role_selector_screen.dart';
import 'screens/volunteer_home_screen.dart';
import 'services/session_manager.dart';

void main() {
  runApp(const VoluntraQApp());
}

class VoluntraQApp extends StatefulWidget {
  const VoluntraQApp({super.key});

  @override
  State<VoluntraQApp> createState() => _VoluntraQAppState();
}

class _VoluntraQAppState extends State<VoluntraQApp> {
  String? _userId;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final userId = await SessionManager.getUserId();
    setState(() {
      _userId = userId;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'VoluntraQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _userId != null 
          ? VolunteerHomeScreen(userId: _userId!) 
          : const RoleSelectorScreen(),
    );
  }
}
