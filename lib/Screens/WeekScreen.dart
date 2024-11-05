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

/*    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                  theme ? Color(0xFF3A3A3A) : Color(0xFFFFFFFF),
                  theme ? Color(0xFF131313) : Color(0xFF999999),
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
                                color: Color(
                                    0xFF959595), // Set icon color from alarm
                                size: 12.0,
                              ),
                              SizedBox(width: 10),
                              Text('Free time',
                                  style: theme
                                      ? secondaryAppBarStyle
                                      : bottomSheetTexts),
                            ],
                          ),
                          Text('1h 12m',
                              style: theme
                                  ? secondaryAppBarStyle
                                  : bottomSheetText), // Show calculated time
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
                                        style: theme
                                            ? secondaryAppBarStyle
                                            : bottomSheetTexts),
                                  ],
                                ),
                                Text(timeFormat,
                                    style: theme
                                        ? secondaryAppBarStyle
                                        : bottomSheetText), // Show calculated time
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
    });*/
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

    debugPrint('selectedDayAlarms = $selectedDayAlarms');

    return SafeArea(
      child: Scaffold(
        appBar:
            CustomAppBar(title: 'Week', theme: theme), // Use the custom AppBar
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 16, left: 16, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Horizontal ListView for days of the week
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
                    SizedBox(height: 20),
                    TimelineStatusPage(alarms: selectedDayAlarms),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 203.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22.0),
                  topLeft: Radius.circular(22.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF999999),
                    Color(0xFFFFFFFF),
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
                                    color: Color(
                                        0xFF959595), // Set icon color from alarm
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Free time',
                                      style: theme
                                          ? secondaryAppBarStyle
                                          : bottomSheetTexts),
                                ],
                              ),
                              Text('1h 12m',
                                  style: theme
                                      ? secondaryAppBarStyle
                                      : bottomSheetText), // Show calculated time
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
                              int totalMinutes =
                                  (alarm.alarmHour * 60 + alarm.alarmMinute) -
                                      (alarm.durationHour * 60 +
                                          alarm.durationMinute);
                              String timeFormat =
                                  '${totalMinutes ~/ 60}h ${totalMinutes % 60}M';

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            style: theme
                                                ? secondaryAppBarStyle
                                                : bottomSheetTexts),
                                      ],
                                    ),
                                    Text(timeFormat,
                                        style: theme
                                            ? secondaryAppBarStyle
                                            : bottomSheetText), // Show calculated time
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
