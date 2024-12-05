import 'package:alarm_clock/Models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../constants.dart';
import 'StaticAlarm.dart';

const kTileHeight = 50.0;

class TimelineStatusPage extends StatefulWidget {
  final List<AlarmModel> alarms;
  final bool theme;
  const TimelineStatusPage(
      {super.key, required this.alarms, required this.theme});

  @override
  State<TimelineStatusPage> createState() => _TimelineStatusPageState();
}

class _TimelineStatusPageState extends State<TimelineStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                _Timeline2(
                  alarms: widget.alarms,
                  theme: widget.theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Timeline2 extends StatelessWidget {
  final List<AlarmModel> alarms;
  final bool theme;

  const _Timeline2({Key? key, required this.alarms, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int freeTime = 0;
    int firstAlarmTime = 0;
    int lastAlarmTime = 0;
    String lastAlarmColor = '';
    bool lastAlarm = false;
    String firstAlarmColor = '';
    bool firstAlarm = false;

    int calculateFirstAlarmTime(AlarmModel alarm) {
      if (alarm.alarmHour > 10) {
        return 7;
      } else if (alarm.alarmHour > 7) {
        return 5;
      } else if (alarm.alarmHour == 0) {
        firstAlarmColor = alarm.alarmColor;
        firstAlarm = true;
        return 0;
      } else {
        return 3;
      }
    }

    int calculateLastAlarmTime(AlarmModel alarm) {
      int difference = 23 - alarm.alarmHour;
      if (difference > 10) {
        return 7;
      } else if (difference > 7) {
        return 5;
      } else if (difference == 0) {
        lastAlarmColor = alarm.alarmColor;
        lastAlarm = true;
        return 0;
      } else {
        return 3;
      }
    }

    int calculateFreeTime(int previousAlarmHour, int currentAlarmHour) {
      int timeDifference = (previousAlarmHour - currentAlarmHour).abs();
      if (timeDifference > 10) {
        return 5;
      } else if (timeDifference > 5) {
        return 3;
      } else if (timeDifference > 0) {
        return 2;
      } else {
        return 0;
      }
    }

    bool checkFirstAlarm(AlarmModel alarm) {
      if (alarm.alarmHour == 0) {
        return true;
      } else
        return false;
    }

    bool checkLastAlarm(AlarmModel alarm) {
      int difference = 23 - alarm.alarmHour;
      if (difference == 0) {
        return true;
      } else
        return false;
    }

    debugPrint("_Timeline2 lastAlarm = $lastAlarm");
    debugPrint("_Timeline2 lastAlarmColor = $lastAlarmColor");
    debugPrint("_Timeline2 firstAlarm = $firstAlarm");
    debugPrint("_Timeline2 firstAlarmColor = $firstAlarmColor");

    List<_TimelineStatus> data = List.generate(
      alarms.length,
      (index) =>
          _TimelineStatus.done, // Assuming all alarms are done for this example
    );

    // Sort alarms by hour and minute
    alarms.sort(
      (a, b) {
        int aTimeInMinutes = a.alarmHour * 60 + a.alarmMinute;
        int bTimeInMinutes = b.alarmHour * 60 + b.alarmMinute;
        return aTimeInMinutes.compareTo(bTimeInMinutes); // Ascending order
      },
    );
    alarms.removeWhere((alarm) => alarm.isEnabled == false);

    if (alarms.isEmpty) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('00:00', style: weekHeaders),
            Flexible(
              child: Timeline.tileBuilder(
                shrinkWrap: true,
                theme: TimelineThemeData(
                  nodePosition: 0,
                  color: Color(0xffc2c5c9),
                  connectorTheme: ConnectorThemeData(
                    thickness: 3.0,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  indicatorBuilder: (context, index) {
                    return DotIndicator(
                      size: 8,
                      color: null,
                    );
                  },
                  connectorBuilder: (_, index, connectorType) {
                    return SolidLineConnector(
                      indent: connectorType == ConnectorType.start ? 0 : 100,
                      endIndent: connectorType == ConnectorType.end ? 0 : 100,
                      color: null,
                    );
                  },
                  contentsBuilder: (_, __) => _EmptyContents(),
                  itemCount: 5,
                  itemExtentBuilder: (_, __) {
                    return 20;
                  }, // Only one item for the empty state
                ),
              ),
            ),
            Text('23:59', style: weekHeaders),
          ],
        ),
      );
    }

    return Expanded(
      child: ListView(
        children: [
          if (alarms.isNotEmpty && !checkFirstAlarm(alarms.first))
            Text('00:00', style: weekHeaders),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: alarms.length,
            itemBuilder: (BuildContext context, int position) {
              DateTime startTime = DateTime(
                0,
                0,
                0,
                alarms[position].alarmHour,
                alarms[position].alarmMinute,
              );
              Duration duration = Duration(
                hours: alarms[position].durationHour,
                minutes: alarms[position].durationMinute,
              );
              DateTime endTime = startTime.add(duration);

              String startTimeFormatted =
                  '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
              String endTimeFormatted =
                  '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

              int freeTime = 0;
              int firstAlarmTime = 0;
              int lastAlarmTime = 0;

              if (position == 0) {
                firstAlarmTime = calculateFirstAlarmTime(alarms[position]);
              }

              if (position == alarms.length - 1) {
                lastAlarmTime = calculateLastAlarmTime(alarms[position]);
              }

              if (position > 0) {
                freeTime = calculateFreeTime(
                  alarms[position - 1].alarmHour,
                  alarms[position].alarmHour,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (firstAlarmTime > 0)
                    Row(
                      children: [
                        Column(
                          children: List.generate(
                            firstAlarmTime,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: DotIndicator(
                                size: 8,
                                color: Color(0xffc2c5c9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (freeTime > 0)
                    Row(
                      children: [
                        Column(
                          children: List.generate(
                            freeTime,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: DotIndicator(
                                size: 8,
                                color: Color(0xffc2c5c9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  theme
                      ? Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDCDCDC), // Fill color
                            border: Border.all(
                              color: Color(0xFFDCDCDC),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text(
                                  startTimeFormatted,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(
                                      int.parse(alarms[position].alarmColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              startTimeFormatted,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(
                                  int.parse(alarms[position].alarmColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Column(
                        children: [
                          if (position < alarms.length)
                            ...List.generate(
                              alarms[position].durationHour > 5 ? 10 : 5,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: DotIndicator(
                                  size: 8,
                                  color: Color(
                                    int.parse(alarms[position].alarmColor),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      Expanded(child: _AlarmContents(alarm: alarms[position])),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        endTimeFormatted,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            int.parse(alarms[position].alarmColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (lastAlarmTime > 0)
                    Row(
                      children: [
                        Column(
                          children: List.generate(
                            lastAlarmTime,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: DotIndicator(
                                size: 8,
                                color: Color(0xffc2c5c9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          if (alarms.isNotEmpty && !checkLastAlarm(alarms.last))
            Text('23:59', style: weekHeaders),
        ],
      ),
    );
  }
}

class _AlarmContents extends StatelessWidget {
  final AlarmModel alarm;

  const _AlarmContents({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Check the state of alarm.alarmDay
    print("Alarm Day: ${alarm.alarmDay}"); // Check what alarm.alarmDay is

    return Container(
      margin: EdgeInsets.only(left: 10.0, top: 15, bottom: 15),
      child: StaticAlarm(alarm: alarm), // Display the individual alarm
    );
  }
}

class _EmptyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
