import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Screens/AlarmScreen.dart';
import 'package:alarm_clock/Screens/SettingsScreen.dart';
import 'package:alarm_clock/Screens/WeekScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Components/BottomNavBar.dart';
import 'Models/alarm_model.dart';
import 'Screens/DayScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter()); // Register the generated adapter
  await Hive.openBox<AlarmModel>('alarm-db'); //
  await Alarm.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFF0F0F0),
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF0F0F0), // Set your AppBar color here
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens to display based on the selected index
  final List<Widget> _screens = [
    DayScreen(),
    AlarmScreen(),
    WeekScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[
          _selectedIndex], // Display the screen based on the selected index
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
