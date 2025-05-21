import 'package:flutter/material.dart';
import 'smartbite_home.dart';
import 'diaryscreen.dart';

class MainScreenWrapper extends StatefulWidget {
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
    // Rely on theme colors for main scaffold background and text
    final theme = Theme.of(context);

    final List<Widget> _widgetOptions = <Widget>[
      SmartBiteHome(onToggleTheme: widget.onToggleTheme),
      DiaryScreen(onToggleTheme: widget.onToggleTheme),
      const Center(child: Text('More Screen Content')),
    ];

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
        // *** IMPORTANT: Make selected and unselected colors theme-aware ***
        selectedItemColor: Colors.green, // You can keep this green for branding
        unselectedItemColor: theme.iconTheme.color?.withOpacity(0.6), // Dimmed based on theme icon color
        backgroundColor: theme.cardColor, // Use card color from theme for background
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}