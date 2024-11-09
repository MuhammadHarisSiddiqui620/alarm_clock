import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  Future<void> triggerAlarm(AlarmModel alarm) async {
    debugPrint('triggerAlarm alarmId= ${alarm.alarmId}');
    debugPrint('triggerAlarm isEnabled= ${alarm.isEnabled}');

    if (alarm.isEnabled == false) {
      Alarm.stop(alarm.alarmId);
      return;
    } else {
      // Pass alarmId as parameter
      final alarmDateTime = getNextAlarmDateTime(
          alarm.alarmHour, alarm.alarmMinute, alarm.alarmDay);

      // Calculate the alarm duration in seconds.
      final double totalDurationSeconds =
          (alarm.durationHour * 60 * 60) + (alarm.durationMinute * 60);

      debugPrint("AlarmMethods alarm.volume= ${alarm.volume}");
      debugPrint("AlarmMethods alarm.vibrate= ${alarm.vibrate}");

      final alarmSettings = AlarmSettings(
        id: alarm.alarmId,
        fadeDuration: totalDurationSeconds,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/audio1.mp3',
        volume: alarm.volume,
        vibrate: alarm.vibrate,
        loopAudio: false,
        notificationSettings: NotificationSettings(
          stopButton: 'Stop',
          title: 'Alarm',
          body: 'Alarm set for ${alarm.alarmDay}',
          icon: 'notification_icon',
        ),
        warningNotificationOnKill: Platform.isIOS,
      );

      await Alarm.set(alarmSettings: alarmSettings);
      Alarm.ringStream.stream.listen(
        (_) => isEnabledChanged(alarm.alarmId),
      );

      debugPrint('Alarm set for $alarmDateTime');
    }
  }

  Future<void> isEnabledChanged(int alarmId) async {
    // Open the box where alarms are stored
    final box = Hive.box<AlarmModel>('alarm-db');

    // Iterate through each alarm in the box and print its values
    for (var alarm in box.values) {
      // Await the future returned by Alarm.isRinging
      bool isRinging = await Alarm.isRinging(alarm.alarmId);
      debugPrint('ALARM METHODS Alarm ID Ringing: $isRinging');

      if (isRinging == true) {
        // If the alarm is found, update the isEnabled field
        alarm.isEnabled = false;
        await alarm.save();
      }
    }
  }
}
