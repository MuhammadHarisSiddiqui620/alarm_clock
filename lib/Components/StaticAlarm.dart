import 'package:flutter/material.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';

class StaticAlarm extends StatefulWidget {
  final AlarmModel alarm;

  const StaticAlarm({
    super.key,
    required this.alarm,
  });

  @override
  State<StaticAlarm> createState() => _StaticAlarmState();
}

class _StaticAlarmState extends State<StaticAlarm> {
  @override
  Widget build(BuildContext context) {
    // Provide a fallback value if activeColor is null
    Color backgroundColor = Color(int.parse(widget.alarm.alarmColor));

    // Calculate start and end times
    DateTime startTime = DateTime(
      0,
      0,
      0,
      widget.alarm.alarmHour,
      widget.alarm.alarmMinute,
    );
    Duration duration = Duration(
      hours: widget.alarm.durationHour,
      minutes: widget.alarm.durationMinute,
    );
    DateTime endTime = startTime.add(duration);

    // Format the time values
    String startTimeFormatted =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    String endTimeFormatted =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      constraints: BoxConstraints(
        minHeight: 83,
        minWidth: 361,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 22, bottom: 14, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.alarm.alarmName,
                    style: dayContainer), // Fallback for null alarmName
              ],
            ),
            Row(
              children: [
                Text(startTimeFormatted, style: weekAlarms),
                SizedBox(width: 10),
                Container(
                  color: Colors.white, // Set the divider color
                  width: 12.0, // Thickness of the divider
                  height: 5.0, // Height of the divider
                ),
                SizedBox(width: 10),
                // Display end time
                Text(endTimeFormatted, style: weekAlarms),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
