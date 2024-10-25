import 'package:flutter/material.dart';

import '../constants.dart';
import 'SwitchState.dart';

class ReusableAlarm extends StatefulWidget {
  final String alarmName;
  final String alarmTime;
  final Color activeColor;

  ReusableAlarm({
    required this.alarmName,
    required this.alarmTime,
    required this.activeColor,
  });

  @override
  State<ReusableAlarm> createState() => _ReusableAlarmState();
}

class _ReusableAlarmState extends State<ReusableAlarm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: new BoxConstraints(
        minHeight: 105,
        minWidth: 361,
      ),
      decoration: BoxDecoration(
        color: widget.activeColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 13, left: 22, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.alarmName, style: dayContainer),
                SwitchState(
                  activeColor: widget.activeColor,
                  inActiveTrackColor: Colors.grey,
                  trackOutlineColor: (Colors.grey[300])!,
                  thumbColor: Colors.white,
                ),
              ],
            ),
            Text(widget.alarmTime, style: dayContainerTimer),
          ],
        ),
      ),
    );
  }
}
