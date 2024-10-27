import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  late String todayDay;

  @override
  void didChangeDependencies() {
    // TODO: Remove it from didChangeDependencies if it doesnot work
    super.didChangeDependencies();
    todayDay = DateFormat('EEEE').format(DateTime.now());
  }

  /// e.g Thursday

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Day'), // Use the custom AppBar
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todayDay,
                    style: dayHeader,
                  ),
                  SizedBox(
                    height: 16,
                  ),
/*                  ReusableAlarm(
                    activeColor: alarmColor[0],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[1],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[2],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[3],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[4],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[5],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[6],
                  ),
                  SizedBox(height: 20),
                  ReusableAlarm(
                    activeColor: alarmColor[7],
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
