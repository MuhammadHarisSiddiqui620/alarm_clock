import 'package:flutter/material.dart';

import '../constants.dart';
import 'SwitchState.dart';

class ReusableAlarm extends StatefulWidget {
  final String? alarmName; // Keep as nullable
  final int? hour; // Keep as nullable
  final int? minute; // Keep as nullable
  final String? activeColor; // Keep as nullable

  ReusableAlarm({
    required this.alarmName,
    required this.hour,
    required this.minute,
    required this.activeColor,
  });

  @override
  State<ReusableAlarm> createState() => _ReusableAlarmState();
}

class _ReusableAlarmState extends State<ReusableAlarm> {
  @override
  Widget build(BuildContext context) {
    // Provide a fallback value if activeColor is null
    Color backgroundColor = Color(
        int.parse(widget.activeColor ?? '0xFF000000')); // Default to black

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
                Text(widget.alarmName ?? 'No Name',
                    style: dayContainer), // Fallback for null alarmName
                SwitchState(
                  activeColor:
                      backgroundColor, // Use the backgroundColor variable
                  inActiveTrackColor: Colors.grey,
                  trackOutlineColor: (Colors.grey[300])!,
                  thumbColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                Text(widget.hour?.toString() ?? '00',
                    style: dayContainerTimer), // Fallback for null hour
                Text(':', style: dayContainerTimer),
                Text(widget.minute?.toString() ?? '00',
                    style: dayContainerTimer), // Fallback for null minute
              ],
            ),
          ],
        ),
      ),
    );
  }
}
