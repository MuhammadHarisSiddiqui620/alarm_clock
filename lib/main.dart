import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Screens/AlarmScreen.dart';
import 'package:alarm_clock/Screens/SettingsScreen.dart';
import 'package:alarm_clock/Screens/WeekScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/BottomNavBar.dart';
import 'Components/ThemeProvider.dart';
import 'Models/alarm_model.dart';
import 'Screens/DayScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter()); // Register the generated adapter
  await Hive.openBox<AlarmModel>('alarm-db'); //
  await Alarm.init();

  // Retrieve theme value
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLightTheme =
      prefs.getBool('selected_theme') ?? false; // Default to false if not set

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  ); // Pass theme value to MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.isLightTheme // Use the theme value
          ? ThemeData.dark().copyWith(
              primaryColor: Color(0xFF272727),
              scaffoldBackgroundColor: Color(0xFF131313),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF272727),
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: Color(0xFFF0F0F0),
              scaffoldBackgroundColor: Color(0xFFFFFFFF),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFFF0F0F0),
              ),
            ),
      home: HomeScreen(theme: themeProvider.isLightTheme),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool theme;

  const HomeScreen({
    Key? key,
    required this.theme,
  }) : super(key: key);

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
        theme: widget.theme,
      ),
    );
  }
}
