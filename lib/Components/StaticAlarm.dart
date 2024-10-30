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

    debugPrint(
        'ReusableAlarm Widget build isEnabled= ${widget.alarm.isEnabled}');

    return Container(
      constraints: BoxConstraints(
        minHeight: 105,
        minWidth: 361,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 13, left: 22, bottom: 24, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.alarm.alarmName ?? 'No Name',
                    style: dayContainer), // Fallback for null alarmName
              ],
            ),
            Row(
              children: [
                Text(widget.alarm.alarmHour.toString(),
                    style: dayContainerTimer), // Fallback for null hour
                Text(':', style: dayContainerTimer),
                Text(widget.alarm.alarmMinute.toString(),
                    style: dayContainerTimer),
                SizedBox(width: 10),
                Divider(
                  thickness: 30,
                  height: 36,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(widget.alarm.durationHour.toString(),
                    style: dayContainerTimer), // Fallback for null hour
                Text(':', style: dayContainerTimer),
                Text(widget.alarm.durationMinute.toString(),
                    style: dayContainerTimer),
// Fallback for null minute
              ],
            ),
          ],
        ),
      ),
    );
  }
}
