import 'package:alarm_clock/Components/AlarmMethods.dart';
import 'package:flutter/material.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';

class ReusableAlarm extends StatefulWidget {
  final AlarmModel alarm;

  const ReusableAlarm({
    super.key,
    required this.alarm,
  });

  @override
  State<ReusableAlarm> createState() => _ReusableAlarmState();
}

class _ReusableAlarmState extends State<ReusableAlarm> {
  AlarmMethods alarms = AlarmMethods();

  @override
  Widget build(BuildContext context) {
    // Provide a fallback value if activeColor is null
    Color backgroundColor =
        Color(int.parse(widget.alarm.alarmColor)); // Default to black

    debugPrint(
        'ReusableAlarm Widget build isEnabled= ${widget.alarm.isEnabled}');

    // Calculate start and end times
    DateTime startTime = DateTime(
      0,
      0,
      0,
      widget.alarm.alarmHour,
      widget.alarm.alarmMinute,
    );

    // Format the time values
    String startTimeFormatted =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

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
                Text(widget.alarm.alarmName,
                    style: dayContainer), // Fallback for null alarmName
                Switch(
                  // This bool value toggles the switch.
                  value: widget.alarm.isEnabled,
                  activeColor: backgroundColor,
                  inactiveTrackColor: Colors.grey,
                  trackOutlineWidth: MaterialStateProperty.all(0.7),
                  trackOutlineColor:
                      MaterialStateProperty.all((Colors.grey[300])!),
                  thumbColor: MaterialStateProperty.all(Colors.white),
                  onChanged: (bool value) async {
                    // This is called when the user toggles the switch.
                    setState(() {
                      debugPrint(
                          'ReusableAlarm isEnabled= ${widget.alarm.isEnabled}');
                      debugPrint(
                          'ReusableAlarm alarmId= ${widget.alarm.alarmId}');
                      // Save the updated alarm state to Hive
                      widget.alarm.isEnabled = value;
                      widget.alarm.save();

                      debugPrint(
                          'ReusableAlarm onChanged alarm= ${widget.alarm.alarmId} + ${widget.alarm.isEnabled}');

                      // Trigger any additional actions (if needed)
                      alarms.triggerAlarm(widget.alarm);
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(startTimeFormatted,
                    style: dayContainerTimer), // Fallback for null hour
              ],
            ),
          ],
        ),
      ),
    );
  }
}
