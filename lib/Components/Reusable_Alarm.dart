import 'package:alarm_clock/Screens/NewAlarm.dart';
import 'package:flutter/material.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';

class ReusableAlarm extends StatefulWidget {
  AlarmModel alarm;

  ReusableAlarm({
    required this.alarm,
  });

  @override
  State<ReusableAlarm> createState() => _ReusableAlarmState();
}

class _ReusableAlarmState extends State<ReusableAlarm> {
  bool light = true;
  static NewAlarm alarms = NewAlarm();

  @override
  Widget build(BuildContext context) {
    // Provide a fallback value if activeColor is null
    Color backgroundColor = Color(
        int.parse(widget.alarm.alarmColor ?? '0xFF000000')); // Default to black

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
                Switch(
                  // This bool value toggles the switch.
                  value: light,
                  activeColor: backgroundColor,
                  inactiveTrackColor: Colors.grey,
                  trackOutlineWidth: MaterialStateProperty.all(0.7),
                  trackOutlineColor:
                      MaterialStateProperty.all((Colors.grey[300])!),
                  thumbColor: MaterialStateProperty.all(Colors.white),
                  onChanged: (bool value) async {
                    // This is called when the user toggles the switch.
                    setState(() {
                      light = value;
                      widget.alarm.isEnabled = value;
                      debugPrint(
                          'ReusableAlarm isEnabled= ${widget.alarm.isEnabled}');
                      debugPrint(
                          'ReusableAlarm alarmId= ${widget.alarm.alarmId}');
                      // Save the updated alarm state to Hive
                      widget.alarm.isEnabled = value;
                      widget.alarm.save();

                      // Trigger any additional actions (if needed)
                      alarms.triggerAlarm(widget.alarm);
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(widget.alarm.alarmHour?.toString() ?? '00',
                    style: dayContainerTimer), // Fallback for null hour
                Text(':', style: dayContainerTimer),
                Text(widget.alarm.alarmMinute?.toString() ?? '00',
                    style: dayContainerTimer), // Fallback for null minute
              ],
            ),
          ],
        ),
      ),
    );
  }
}
