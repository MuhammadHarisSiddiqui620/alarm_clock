import 'package:flutter/material.dart';

import '../constants.dart';
import 'SwitchState.dart';

class ReusableAlarm extends StatefulWidget {
  ReusableAlarm({
    required this.activeColor,
  });

  final Color activeColor;

  @override
  State<ReusableAlarm> createState() => _ReusableAlarmState();
}

class _ReusableAlarmState extends State<ReusableAlarm> {
  bool value = false;
  Color? colour = null;
  String alarmName = 'dummy';
  String alarmTime = '07:00';

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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(alarmName, style: dayContainer),
                    SwitchState(
                      activeColor: widget.activeColor,
                      inActiveTrackColor: Colors.grey,
                      trackOutlineColor: (Colors.grey[300])!,
                      thumbColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Text(alarmTime, style: dayContainerTimer),
            ],
          ),
        ),
      ),
    );
  }
}
