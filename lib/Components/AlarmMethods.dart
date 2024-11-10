import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AlarmMethods {
  List<AlarmModel> alarms = [];

  // Make the broadcast stream static to ensure it's only initialized once
  static final Stream<void> ringBroadcastStream =
      Alarm.ringStream.stream.asBroadcastStream();

  AlarmMethods() {
    // Listen to the broadcast stream once in the constructor
    ringBroadcastStream.listen((_) async {
      await onRing();
    });
  }

  // This function is called whenever the alarm rings
  Future<void> onRing() async {
    await isEnabledChanged();
  }

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

  Future<void> triggerAlarm() async {
    await loadAlarms();

    for (var alarm in alarms) {
      debugPrint("AlarmMethods triggerAlarm alarmId= ${alarm.alarmId}");
      debugPrint("AlarmMethods triggerAlarm alarm= ${alarm.isEnabled}");
      debugPrint("AlarmMethods triggerAlarm alarms Length= ${alarms.length}");

      if (!alarm.isEnabled) {
        Alarm.stop(alarm.alarmId);
        continue;
      } else {
        final alarmDateTime = getNextAlarmDateTime(
            alarm.alarmHour, alarm.alarmMinute, alarm.alarmDay);

        final double totalDurationSeconds =
            (alarm.durationHour * 60 * 60) + (alarm.durationMinute * 60);

        final alarmSettings = AlarmSettings(
          id: alarm.alarmId,
          fadeDuration: totalDurationSeconds,
          dateTime: alarmDateTime,
          assetAudioPath: 'assets/audio1.mp3',
          volume: alarm.volume,
          vibrate: alarm.vibrate,
          loopAudio: true,
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
  }

  Future<void> isEnabledChanged() async {
    final box = Hive.box<AlarmModel>('alarm-db');

    for (var alarm in box.values) {
      bool isRinging = await Alarm.isRinging(alarm.alarmId);

      if (isRinging == true) {
        alarm.isEnabled = false;
        await alarm.save();
      }
    }
  }

  Future<void> loadAlarms() async {
    alarms.clear();
    var box = Hive.box<AlarmModel>('alarm-db');

    for (var alarm in box.values) {
      alarms.add(alarm);
    }
  }
}
