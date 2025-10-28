import 'package:ergovision/configuration/views/configuration.dart';
import 'package:ergovision/configuration/views/profile.dart';
import 'package:ergovision/monitoring/views/sessions.dart';
import 'package:ergovision/shared/views/dashboard.dart';
import 'package:ergovision/statistics/views/statistics.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    Dashboard(),
    Sessions(),
    Statistics(),
    Profile(),
    Configuration()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF1E2430),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (idx) => setState(() => currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.airplay), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
