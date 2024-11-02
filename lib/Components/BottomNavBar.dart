import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool theme;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme ? Color(0XFF3D3D3D) : Color(0XFFF0F0F0),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.bolt),
          label: 'Day',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Alarms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Week',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFFFD0746),
      unselectedItemColor:
          theme ? Color(0xFFFFFFFF) : Colors.grey, // Color for inactive items
      onTap: onTap,
    );
  }
}
