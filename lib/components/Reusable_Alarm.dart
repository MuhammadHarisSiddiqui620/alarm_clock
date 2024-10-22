import 'package:flutter/material.dart';

import '../constants.dart';
import 'SwitchState.dart';

class ResuableAlarm extends StatefulWidget {
  ResuableAlarm({
    required this.activeColor,
  });

  final Color activeColor;

  @override
  State<ResuableAlarm> createState() => _ResuableAlarmState();
}

class _ResuableAlarmState extends State<ResuableAlarm> {
  bool value = false;
  Color? colour = null;

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
                    Text('dummy', style: dayContainer),
                    SwitchState(
                      activeColor: widget.activeColor,
                      inActiveTrackColor: Colors.grey,
                      trackOutlineColor: (Colors.grey[300])!,
                      thumbColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Text('07:00', style: dayContainerTimer),
            ],
          ),
        ),
      ),
    );
  }
}
