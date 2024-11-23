import 'package:alarm_clock/Models/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../constants.dart';
import 'StaticAlarm.dart';

const kTileHeight = 50.0;

class TimelineStatusPage extends StatefulWidget {
  final List<AlarmModel> alarms;

  const TimelineStatusPage({super.key, required this.alarms});

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
                _Timeline2(alarms: widget.alarms),
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

  const _Timeline2({Key? key, required this.alarms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('00:00', style: weekHeaders),
          Flexible(
            child: Timeline.tileBuilder(
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
                    color: data[index] == _TimelineStatus.done
                        ? Color(int.parse(alarms[index].alarmColor))
                        : null,
                  );
                },
                connectorBuilder: (_, index, connectorType) {
                  var color;
                  if (index + 1 < data.length - 1) {
                    color =
                        data[index].isInProgress && data[index + 1].isInProgress
                            ? Color(0xff193fcc)
                            : null;
                  }
                  return DotIndicator(size: 8, color: color);
                },
                contentsBuilder: (context, index) {
                  return _AlarmContents(alarm: alarms[index]);
                },
                itemCount: data.length,
              ),
            ),
          ),
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

    return alarm.alarmDay.isEmpty
        ? Container(
            margin: EdgeInsets.only(left: 10.0),
            height: 10.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: Color(0xffe6e7e9),
            ),
          )
        : Container(
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
