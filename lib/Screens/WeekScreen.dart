import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Week'), // Use the custom AppBar
        body: Center(
          child: Text('Settings screen content'),
        ),
      ),
    );
  }
}
