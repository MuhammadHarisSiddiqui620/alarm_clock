import 'package:alarm_clock/Components/AlarmMethods.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Models/alarm_model.dart';
import '../constants.dart';

class ReusableAlarmWidget extends StatefulWidget {
  final AlarmModel alarm;
  final bool onTap;
  final Function() onDelete; // Add a callback for delete action

  const ReusableAlarmWidget({
    super.key,
    required this.alarm,
    required this.onTap,
    required this.onDelete, // Pass this from AlarmScreen
  });

  @override
  State<ReusableAlarmWidget> createState() => _ReusableAlarmWidgetState();
}

class _ReusableAlarmWidgetState extends State<ReusableAlarmWidget> {
  AlarmMethods alarms = AlarmMethods();
  var box = Hive.box<AlarmModel>('alarm-db');
  AlarmMethods triggerAlarm = AlarmMethods();

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
        padding: const EdgeInsets.only(left: 22),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 13),
                                    Text(widget.alarm.alarmName,
                                        style: dayContainer),
                                    SizedBox(height: 7),
                                    Text(startTimeFormatted,
                                        style: dayContainerTimer),
                                    SizedBox(height: 24),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.onTap
                  ? Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(''),
                                Switch(
                                  // This bool value toggles the switch.
                                  value: widget.alarm.isEnabled,
                                  activeColor: backgroundColor,
                                  inactiveTrackColor: Colors.grey,
                                  trackOutlineWidth:
                                      MaterialStateProperty.all(0.7),
                                  trackOutlineColor: MaterialStateProperty.all(
                                      (Colors.grey[300])!),
                                  thumbColor:
                                      MaterialStateProperty.all(Colors.white),
                                  onChanged: (bool value) async {
                                    setState(() {
                                      widget.alarm.isEnabled = value;
                                      widget.alarm.save();
                                    });
                                  },
                                ),
                                Text(''),
                                Text(''),
                                Text(''),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          // Find the alarm in the box by its ID and delete it
                          var _task = box.values
                              .where((_) => _.alarmId == widget.alarm.alarmId)
                              .first;
                          _task.delete();

                          // Notify the parent widget to refresh the alarm list
                          triggerAlarm.triggerAlarm();
                          widget.onDelete();
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 130,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0xFFFD0746),
                                Color(0xFFAD022B),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 32,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
