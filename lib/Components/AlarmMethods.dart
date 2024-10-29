import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmMethods {
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

  Future<void> triggerAlarm(int? alarmId, int? selectedAlarmHour,
      int? selectedAlarmMinute, String selectedDay) async {
    debugPrint('alarmId= $alarmId');

    // Pass alarmId as parameter
    if (selectedAlarmHour == null || selectedAlarmMinute == null) return;

    // Only set the alarm if isEnabled is true
    final alarmDateTime = getNextAlarmDateTime(
        selectedAlarmHour, selectedAlarmMinute, selectedDay);

    final alarmSettings = AlarmSettings(
      id: alarmId!,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/audio1.mp3',
      volume: 0.5,
      notificationSettings: NotificationSettings(
        stopButton: 'Stop',
        title: 'Alarm',
        body: 'Alarm set for ${selectedDay}',
        icon: 'notification_icon',
      ),
      warningNotificationOnKill: Platform.isIOS,
    );

    await Alarm.set(alarmSettings: alarmSettings);
    debugPrint('Alarm set for $alarmDateTime');
  }

  void stopAlarm(int? alarmId) {
    Alarm.stop(alarmId!);
  }

  void saveInDb() {}
}
