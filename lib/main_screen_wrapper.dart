// lib/main_screen_wrapper.dart

import 'package:flutter/material.dart';
import 'smartbite_home.dart';
import 'diaryscreen.dart';
import 'settings_screen.dart'; // <--- NEW: Import the SettingsScreen

class MainScreenWrapper extends StatefulWidget {
  // Keep the original signature for onToggleTheme
  final void Function()? onToggleTheme;

  MainScreenWrapper({super.key, this.onToggleTheme});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- MODIFIED: Use SettingsScreen for the 'More' tab ---
    final List<Widget> _widgetOptions = <Widget>[
      SmartBiteHome(onToggleTheme: widget.onToggleTheme),
      DiaryScreen(onToggleTheme: widget.onToggleTheme),
      // Here, we pass the original onToggleTheme down to SettingsScreen
      SettingsScreen(onToggleTheme: widget.onToggleTheme), // <--- NEW: SettingsScreen for 'More' tab
    ];
    // --- END MODIFIED ---

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: theme.iconTheme.color?.withOpacity(0.6),
        backgroundColor: theme.cardColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}