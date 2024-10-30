import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Components/CustomAppBar.dart';
import '../Components/SmartWheelPicker.dart';
import '../Components/SwitchState.dart';
import '../Components/WheelPicker.dart';
import '../Models/alarm_model.dart';
import '../constants.dart';
import 'AlarmScreen.dart';

class NewAlarm extends StatefulWidget {
  final String selectedDay;

  const NewAlarm({super.key, required this.selectedDay});

  // Helper function to calculate the next alarm DateTime for the selected day
  DateTime getNextAlarmDateTime(int hour, int minute, String selectedDay) {
    final now = DateTime.now();
    int currentDayIndex = now.weekday;
    int selectedDayIndex = getDayIndex(selectedDay);

    int daysUntilAlarm = (selectedDayIndex - currentDayIndex + 7) % 7;
    if (daysUntilAlarm == 0 &&
        (hour < now.hour || (hour == now.hour && minute <= now.minute))) {
      daysUntilAlarm = 7; // Set for next week if time has passed today
    }

    debugPrint('daysUntilAlarm= $daysUntilAlarm');

    return DateTime(
        now.year, now.month, now.day + daysUntilAlarm, hour, minute);
  }

  int getDayIndex(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return DateTime.now().weekday; // Default to current day if invalid
    }
  }

  Future<void> triggerAlarm(AlarmModel alarm) async {
    debugPrint('triggerAlarm alarmId= ${alarm.alarmId}');
    debugPrint('triggerAlarm isEnabled= ${alarm.isEnabled}');

    if (alarm.isEnabled == false) {
      debugPrint('triggerAlarm isEnabled false');
      Alarm.stop(alarm.alarmId);
    } else {
      debugPrint('triggerAlarm isEnabled true');

      // Only set the alarm if isEnabled is true
      final alarmDateTime = getNextAlarmDateTime(
          alarm.alarmHour, alarm.alarmMinute, alarm.alarmDay);

      final alarmSettings = AlarmSettings(
        id: alarm.alarmId,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/audio1.mp3',
        volume: 0.5,
        notificationSettings: NotificationSettings(
          stopButton: 'Stop',
          title: 'Alarm',
          body: 'Alarm set for ${alarm.alarmDay}',
          icon: 'notification_icon',
        ),
        warningNotificationOnKill: Platform.isIOS,
      );

      await Alarm.set(alarmSettings: alarmSettings);
      debugPrint('Alarm set for $alarmDateTime');
    }
  }

  @override
  State<NewAlarm> createState() => _NewAlarmState();
}

class _NewAlarmState extends State<NewAlarm> {
  String alarmName = '';
  int selectedDurationHour = 0;
  int selectedDurationMinute = 0;
  int selectedAlarmHour = 0;
  int selectedAlarmMinute = 0;
  String selectedThemeColor = '';
  late DateTime selectedDateTime;
  int alarmId = 0;

  // Helper function to calculate the next alarm DateTime for the selected day
  DateTime getNextAlarmDateTime(int hour, int minute, String selectedDay) {
    final now = DateTime.now();
    int currentDayIndex = now.weekday;
    int selectedDayIndex = getDayIndex(selectedDay);

    int daysUntilAlarm = (selectedDayIndex - currentDayIndex + 7) % 7;
    if (daysUntilAlarm == 0 &&
        (hour < now.hour || (hour == now.hour && minute <= now.minute))) {
      daysUntilAlarm = 7; // Set for next week if time has passed today
    }

    debugPrint('daysUntilAlarm= $daysUntilAlarm');

    return DateTime(
        now.year, now.month, now.day + daysUntilAlarm, hour, minute);
  }

  int getDayIndex(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return DateTime.now().weekday; // Default to current day if invalid
    }
  }

  Future<void> triggerAlarm(AlarmModel alarm) async {
    debugPrint('triggerAlarm alarmId= ${alarm.alarmId}');
    debugPrint('triggerAlarm isEnabled= ${alarm.isEnabled}');

    if (alarm.isEnabled == false) {
      return;
    } else {
      // Pass alarmId as parameter
      final alarmDateTime = getNextAlarmDateTime(
          alarm.alarmHour, alarm.alarmMinute, alarm.alarmDay);

      final alarmSettings = AlarmSettings(
        id: alarm.alarmId,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/audio1.mp3',
        volume: 0.5,
        notificationSettings: NotificationSettings(
          stopButton: 'Stop',
          title: 'Alarm',
          body: 'Alarm set for ${alarm.alarmDay}',
          icon: 'notification_icon',
        ),
        warningNotificationOnKill: Platform.isIOS,
      );

      await Alarm.set(alarmSettings: alarmSettings);
      debugPrint('Alarm set for $alarmDateTime');
    }
  }

  void stopAlarm(int? alarmId) {
    Alarm.stop(alarmId!);
  }

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
                    style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16),
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
                    child: WheelPickerExample(
                      onValueChanged: (hour, minute) {
                        setState(() {
                          selectedAlarmHour = hour;
                          selectedAlarmMinute = minute;
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF0B0D9C),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF0B0D9C),
                            Color(0xFF9711B3),
                          ],
                        )),
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
                      WheelPicker(
                        onValueChanged: (hour, minute) {
                          setState(() {
                            selectedDurationHour = hour;
                            selectedDurationMinute = minute;
                          });
                        },
                      ),
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
                          getTheme('0xFF1A2C68'),
                          SizedBox(width: 8),
                          getTheme('0xFF681A1A'),
                          SizedBox(width: 8),
                          getTheme('0xFF906818'),
                          SizedBox(width: 8),
                          getTheme('0xFF24801F'),
                          SizedBox(width: 8),
                          getTheme('0xFF751C66'),
                          SizedBox(width: 8),
                          getTheme('0xFF1C6675'),
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
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('Save this alarm', style: buttonTextStyle),
                    onPressed: () async {
                      // Check if time and duration values are set
                      if (selectedAlarmHour != '' && selectedThemeColor != '') {
                        debugPrint('durationValue= ${selectedDurationHour}');
                        debugPrint('durationValue= ${selectedDurationMinute}');
                        debugPrint('durationValue= ${selectedAlarmHour}');
                        debugPrint('durationValue= ${selectedAlarmMinute}');

                        // Create an AlarmModel object with the input data
                        AlarmModel alarm = AlarmModel(
                          alarmId: alarmId + 1, // Set to null initially
                          alarmName:
                              alarmName.isEmpty ? 'Default Alarm' : alarmName,
                          alarmHour: selectedAlarmHour,
                          alarmMinute: selectedAlarmMinute,
                          durationHour: selectedDurationHour,
                          durationMinute: selectedDurationMinute,
                          alarmColor: selectedThemeColor,
                          alarmDay: widget.selectedDay,
                          isEnabled: true,
                        );

                        // Access the 'alarms' box and add the new alarm
                        final box = Hive.box<AlarmModel>('alarm-db');
                        alarmId = await box.add(alarm) + 1;

                        alarm.alarmId = alarmId;
                        alarm.save();
                        triggerAlarm(alarm);

                        debugPrint('box length= ${box.length}');

                        // Optionally navigate back or show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Alarm saved successfully!')),
                        );
                        Navigator.pop(context); // Go back to previous screen
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please set all alarm details.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAD022B),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                      minimumSize: Size(double.infinity, 57),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded getTheme(String colour) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedThemeColor = colour; // Set the selected color
          });
        },
        child: Container(
          height: 50,
          width: 50,
          child: Card(
            color: Color(int.parse(colour)),
            margin: EdgeInsets.all(5),
            shape: selectedThemeColor == colour
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black, width: 2),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
