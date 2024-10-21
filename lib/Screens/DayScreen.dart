import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../components/Reusable_Alarm.dart';
import '../constants.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Day'), // Use the custom AppBar
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: Column(
                children: [
                  Text(
                    'Monday',
                    style: dayHeader,
                  ),
                  ResuableAlarm(),
                  SizedBox(height: 20),
                  ResuableAlarm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
