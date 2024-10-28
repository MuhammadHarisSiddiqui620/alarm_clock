import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:alarm_clock/components/Reusable_Alarm.dart';
import 'package:alarm_clock/models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import '../constants.dart';
import 'NewAlarm.dart'; // Your constants file

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // Track the selected day (e.g., Monday, Tuesday)
  String selectedDay = 'Monday';

  // Store all alarms for the selected day
  List<AlarmModel> alarms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAlarms(); // Load alarms from Hive
  }

  Future<void> _loadAlarms() async {
    var box = Hive.box<AlarmModel>('alarm-db');
    setState(() {
      alarms =
          box.values.where((alarm) => alarm.alarmDay == selectedDay).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get alarms for the selected day
    List<AlarmModel> selectedDayAlarms = alarms.toList();

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Alarms'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Horizontal ListView for days of the week
              Container(
                height: 50,
                margin: EdgeInsets.only(
                    left: screenWidth * 0.5 - 50), // 50% of screen width
                child: ListView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  children: [
                    getDayWidget('Monday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Tuesday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Wednesday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Thursday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Friday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Saturday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Sunday'),
                  ],
                ),
              ),

              // Display alarms for the selected day
              Expanded(
                child: selectedDayAlarms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/no-alarm.svg',
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 21),
                            Text('You haven’t created alarms',
                                style: appBarStyle),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedDayAlarms.length,
                        itemBuilder: (context, index) {
                          final alarm = selectedDayAlarms[index];
                          return ReusableAlarm(
                            alarmName: alarm.alarmName,
                            hour: alarm.alarmHour,
                            minute: alarm.alarmMinute,
                            activeColor: alarm.alarmColor,
                          );
                        },
                      ),
              ),

              SizedBox(
                height: 20,
              ),

              // Add new alarm button, only show if alarms exist for the day
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9711B3),
                      minimumSize: Size(172, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the NewAlarmScreen when the button is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewAlarm(
                                  selectedDay: selectedDay,
                                )),
                      );
                    },
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Add new alarm',
                              style: buttonTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for each day button in the horizontal list
  GestureDetector getDayWidget(String day) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
          _loadAlarms(); // Load alarms when a day is selected
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          day,
          style: TextStyle(
            color: selectedDay == day ? Color(0xFF131313) : Color(0xFF7E7E7E),
            fontFamily: 'Roboto',
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
