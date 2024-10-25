import 'package:alarm_clock/components/Reusable_Alarm.dart';
import 'package:alarm_clock/components/SmartWheelPicker.dart';
import 'package:flutter/material.dart';

import '../components/CustomAppBar.dart';
import '../components/SwitchState.dart';
import '../components/WheelPicker.dart';
import '../constants.dart';

class NewAlarm extends StatefulWidget {
  const NewAlarm({super.key});

  @override
  State<NewAlarm> createState() => _NewAlarmState();
}

class _NewAlarmState extends State<NewAlarm> {
  String alarmName = '';
  String alarmTime = '07:00'; // Default time
  String duration = '5 mins'; // Default duration

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'New alarm'),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                children: [
                  Text('Alarm name', style: newAlarmTextStyle),
                  SizedBox(height: 2),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        alarmName = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Meeting with...',
                    ),
                  ),
                  SizedBox(height: 23),
                  Text('Time', style: newAlarmTextStyle),
                  SizedBox(height: 6),
                  Container(
                    width: 199,
                    height: 77,
                    child: WheelPickerExample(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF9711B3),
                    ),
                  ),
                  SizedBox(height: 44),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Temporary', style: appBarStyle),
                          Text(
                            'You can set a one-time alarm. \nIt will only go off once',
                            style: secondaryTextColor,
                          ),
                        ],
                      ),
                      SwitchState(
                        activeColor: settingSwitch,
                        trackOutlineColor: settingSwitch,
                        thumbColor: (Colors.grey[300])!,
                        inActiveTrackColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 23),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration', style: appBarStyle),
                      SizedBox(height: 8),
                      WheelPicker(),
                    ],
                  ),
                  SizedBox(height: 23),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme', style: appBarStyle),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          getTheme(Color(0xFF1A2C68)),
                          SizedBox(width: 8),
                          getTheme(Color(0xFF681A1A)),
                          SizedBox(width: 8),
                          getTheme(Color(0xFF906818)),
                          SizedBox(width: 8),
                          getTheme(Color(0xFF24801F)),
                          SizedBox(width: 8),
                          getTheme(Color(0xFF751C66)),
                          SizedBox(width: 8),
                          getTheme(Color(0xFF1C6675)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // The save button is now placed at the bottom
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ElevatedButton(
                child: Text('Save this alarm', style: buttonTextStyle),
                onPressed: () {
                  // Pass the alarm data back to the previous screen
                  Navigator.pop(
                    context,
                    ReusableAlarm(
                      activeColor: Colors.purple,
                      alarmName: alarmName,
                      alarmTime: alarmTime,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFAD022B),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                  ),
                  minimumSize: Size(double.infinity, 57),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded getTheme(Color colour) {
    return Expanded(
      child: Container(
        height: 50,
        width: 50,
        child: Card(
          color: colour,
          margin: EdgeInsets.all(5),
        ),
      ),
    );
  }
}
