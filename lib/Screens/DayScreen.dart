import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Components/CustomAppBar.dart';
import 'package:alarm_clock/Components/Reusable_Alarm.dart';
import 'package:alarm_clock/Screens/AlarmScreen.dart';
import 'package:alarm_clock/Services/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';
import '../main.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  late String todayDay;
  List<AlarmModel> alarms = [];
  bool theme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }
    todayDay = DateFormat('EEEE').format(DateTime.now());
    _loadAlarms(); // Load alarms from Hive
    getThemeValueFlag();
  }

  Future<void> _loadAlarms() async {
    var box = Hive.box<AlarmModel>('alarm-db');
    DateTime now = DateTime.now();

    setState(() {
      alarms = box.values.where((alarm) => alarm.alarmDay == todayDay).toList();

      // Sort by time, placing alarms after the current time first
      alarms.sort((a, b) {
        int aTime = a.alarmHour * 60 + a.alarmMinute;
        int bTime = b.alarmHour * 60 + b.alarmMinute;
        int currentTime = now.hour * 60 + now.minute;

        bool aIsAfterNow = aTime >= currentTime;
        bool bIsAfterNow = bTime >= currentTime;

        if (aIsAfterNow && !bIsAfterNow) return -1;
        if (!aIsAfterNow && bIsAfterNow) return 1;

        return aTime.compareTo(bTime);
      });
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

  /// e.g Thursday

  @override
  Widget build(BuildContext context) {
    List<AlarmModel> selectedDayAlarms = alarms.toList();
    debugPrint('selectedDayAlarms = ${selectedDayAlarms.length}');
    return SafeArea(
      child: Scaffold(
        appBar:
            CustomAppBar(title: 'Day', theme: theme), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayDay,
                      style: theme ? secondaryDayHeader : dayHeader,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                    child: selectedDayAlarms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'images/no-alarm.svg',
                                  width: 100,
                                  height: 100,
                                  color: theme ? Colors.white : Colors.black,
                                ),
                                SizedBox(height: 21),
                                Text(
                                    "You don't have any active timers for today. You can create them in the Alarms screen",
                                    textAlign: TextAlign.center,
                                    style: theme
                                        ? secondaryAppBarStyle
                                        : appBarStyle),
                                SizedBox(
                                  height: 47,
                                ),
                                Container(
                                  height: 57,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      HomeScreen.of(context)
                                          ?.setSelectedIndex(1);
                                    },
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color(0xFFFD0746),
                                            Color(0xFFAD022B),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                12), // adjust padding if needed
                                        child: const Text(
                                          "Go to alarms",
                                          style: secondaryAppBarStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: selectedDayAlarms.length,
                            itemBuilder: (context, index) {
                              final alarm = selectedDayAlarms[index];
                              return ReusableAlarm(alarm: alarm);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 20);
                            },
                          ),
                    onRefresh: _loadAlarms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
