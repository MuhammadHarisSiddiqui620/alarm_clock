import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Alarms'), // Use the custom AppBar
        body: Center(
          child: Text('Alarms screen content'),
        ),
      ),
    );
  }
}
