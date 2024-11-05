import 'package:alarm_clock/Components/CustomAppBar.dart';
import 'package:alarm_clock/Components/TimelineStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late FixedExtentScrollController _scrollController;
  bool theme = false;

  // List of days of the week
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 0);
    _loadAlarms(); // Load alarms from Hive
    getThemeValueFlag();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    var box = Hive.box<AlarmModel>('alarm-db');
    setState(() {
      alarms =
          box.values.where((alarm) => alarm.alarmDay == selectedDay).toList();
    });
  }

  Future<void> getThemeValueFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('selected_theme') != null) {
      setState(() {
        theme = prefs.getBool('selected_theme')!;
      });
    } else {
      setState(() {
        theme = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get alarms for the selected day
    List<AlarmModel> selectedDayAlarms = alarms.toList();

    // Calculate total alarm time in minutes
    int totalAlarmTimeInMinutes = selectedDayAlarms.fold(0,
        (sum, alarm) => sum + (alarm.durationHour * 60) + alarm.durationMinute);

    // Calculate free time in minutes
    int freeTimeInMinutes =
        1440 - totalAlarmTimeInMinutes; // 1440 minutes in a day

    // Convert free time back to hours and minutes
    int freeTimeHours = freeTimeInMinutes ~/ 60;
    int freeTimeMinutes = freeTimeInMinutes % 60;
    // Conditional display of free time
    String freeTimeText = '';
    if (freeTimeHours > 0) {
      freeTimeText += '${freeTimeHours}h';
    }
    if (freeTimeMinutes > 0) {
      if (freeTimeText.isNotEmpty)
        freeTimeText += ' '; // Add space if hours are also displayed
      freeTimeText += '${freeTimeMinutes}m';
    }

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Week', theme: theme),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 16, left: 16, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: ListWheelScrollView.useDelegate(
                          controller: _scrollController,
                          itemExtent: 120,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedDay = daysOfWeek[index];
                              _loadAlarms();
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: RotatedBox(
                                  quarterTurns: -3,
                                  child: Text(
                                    daysOfWeek[index],
                                    style: TextStyle(
                                      color: selectedDay == daysOfWeek[index]
                                          ? theme
                                              ? Color(0xFFFFFFFF)
                                              : Color(0xFF131313)
                                          : Color(0xFF7E7E7E),
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: daysOfWeek.length,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(
                      color: Color(0xFFB1B1B1),
                      thickness: 1,
                    ),
                    SizedBox(height: 27),
                    TimelineStatusPage(alarms: selectedDayAlarms),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 203.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22.0),
                  topLeft: Radius.circular(22.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    theme ? Color(0xFF3A3A3A) : Color(0xFFFFFFFF),
                    theme ? Color(0xFF131313) : Color(0xFF999999),
                  ],
                ),
              ),
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('d MMMM').format(DateTime.now()),
                            style: theme ? dayContainer : bottomSheetTextheader,
                          ),
                          SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Color(0xFF959595),
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Free time',
                                      style: theme
                                          ? secondaryAppBarStyle
                                          : bottomSheetTexts),
                                ],
                              ),
                              Text(freeTimeText,
                                  style: theme
                                      ? secondaryAppBarStyle
                                      : bottomSheetText),
                            ],
                          ),

                          SizedBox(height: 15),

                          // ListView.builder for alarms
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: alarms.length,
                            itemBuilder: (context, index) {
                              final alarm = alarms[index];

                              String alarmDuration = "";
                              if (alarm.durationHour != 0) {
                                alarmDuration = "${alarm.durationHour}h";
                              } else {
                                alarmDuration = "${alarm.durationMinute}m";
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(
                                                  int.parse(alarm.alarmColor)),
                                              size: 12.0,
                                            ),
                                            SizedBox(width: 10),
                                            Text(alarm.alarmName,
                                                style: theme
                                                    ? secondaryAppBarStyle
                                                    : bottomSheetTexts),
                                          ],
                                        ),
                                        Text(alarmDuration,
                                            style: theme
                                                ? secondaryAppBarStyle
                                                : bottomSheetText),
                                      ],
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
