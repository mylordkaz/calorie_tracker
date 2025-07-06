import 'package:flutter/material.dart';
import 'package:nibble/l10n/app_localizations.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/libraries/library_screen.dart';
import '../../features/stats/screens/stats_screen.dart';
import '../../features/tools/screens/tools_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    LibraryScreen(),
    StatsScreen(),
    ToolsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: l10n.library,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: l10n.stats,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: l10n.tools),
        ],
      ),
    );
  }
}
