import 'package:alarm/alarm.dart';
import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:alarm_clock/components/Reusable_Alarm.dart';
import 'package:alarm_clock/services/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/alarm_model.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  late String todayDay;
  List<AlarmModel> alarms = [];

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
  }

  Future<void> _loadAlarms() async {
    var box = Hive.box<AlarmModel>('alarm-db');
    setState(() {
      alarms = box.values.where((alarm) => alarm.alarmDay == todayDay).toList();
    });
  }

  /// e.g Thursday

  @override
  Widget build(BuildContext context) {
    List<AlarmModel> selectedDayAlarms = alarms.toList();
    debugPrint('selectedDayAlarms = ${selectedDayAlarms.length}');
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Day'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
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
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
