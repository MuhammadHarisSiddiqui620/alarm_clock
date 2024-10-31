import 'package:alarm_clock/Components/CustomAppBar.dart';
import 'package:alarm_clock/Components/TimelineStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  // Track the selected day (e.g., Monday, Tuesday)
  String selectedDay = 'Monday';

  // Store all alarms for the selected day
  List<AlarmModel> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms(); // Load alarms from Hive

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Ensures the bottom sheet wraps content size
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(
                16), // Add padding to avoid content touching edges
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF999999),
                ],
              ),
            ),
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('d MMMM').format(DateTime.now()),
                        style: bottomSheetTextheader,
                      ),
                      SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(
                                    0xFF959595), // Set icon color from alarm
                                size: 12.0,
                              ),
                              SizedBox(width: 10),
                              Text('Free time', style: bottomSheetTexts),
                            ],
                          ),
                          Text('1h 12m',
                              style: bottomSheetText), // Show calculated time
                        ],
                      ),

                      SizedBox(height: 15),

                      // ListView.builder for alarms
                      ListView.builder(
                        shrinkWrap: true, // Prevents infinite height
                        itemCount: alarms.length,
                        itemBuilder: (context, index) {
                          final alarm = alarms[index];
                          // Calculate remaining time
                          int totalMinutes = (alarm.alarmHour * 60 +
                                  alarm.alarmMinute) -
                              (alarm.durationHour * 60 + alarm.durationMinute);
                          String timeFormat =
                              '${totalMinutes ~/ 60}h ${totalMinutes % 60}M';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(int.parse(alarm
                                          .alarmColor)), // Set icon color from alarm
                                      size: 12.0,
                                    ),
                                    SizedBox(width: 10),
                                    Text(alarm.alarmName,
                                        style: bottomSheetTexts),
                                  ],
                                ),
                                Text(timeFormat,
                                    style:
                                        bottomSheetText), // Show calculated time
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
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

    debugPrint('selectedDayAlarms = $selectedDayAlarms');

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Week'), // Use the custom AppBar
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
              TimelineStatusPage(alarms: selectedDayAlarms),
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
