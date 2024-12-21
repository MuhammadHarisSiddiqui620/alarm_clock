import 'dart:developer';

import 'package:flutter/material.dart';
import '../Components/StaticAlarm.dart';
import '../Models/alarm_model.dart';
import '../constants.dart';

class NewTimeline extends StatefulWidget {
  final List<AlarmModel> alarms;
  final bool theme;

  const NewTimeline({super.key, required this.alarms, required this.theme});

  @override
  State<NewTimeline> createState() => _NewTimelineState();
}

class _NewTimelineState extends State<NewTimeline> {
  List<Color> timelineColors =
  List.generate(23, (_) => Colors.grey); // Default grey color for 24 hours

  @override
  void initState() {
    super.initState();
/*
    print("NewTimeline initState");
*/
    _generateTimelineColors();
  }

  // Generate the timeline colors based on alarm times
  void _generateTimelineColors() {
    // Reset the timeline
    timelineColors = List.generate(23, (_) => Colors.grey);

    widget.alarms.sort(
          (a, b) {
        int aTimeInMinutes = a.alarmHour * 60 + a.alarmMinute;
        int bTimeInMinutes = b.alarmHour * 60 + b.alarmMinute;
        return aTimeInMinutes.compareTo(bTimeInMinutes); // Ascending order
      },
    );

    for (var alarm in widget.alarms) {
/*
      print("NewTimeline alarm ${alarm}");
*/
      int startHour = alarm.alarmHour;
      int endHour = (alarm.alarmHour + alarm.durationHour) %
          24; // Handle wrapping around 24 hours
      String alarmColorHex = alarm.alarmColor;

      Color alarmColor = _hexToColor(alarmColorHex);

      // Fill in the timeline with the alarm color
      if (startHour <= endHour) {
        // Normal case: No wrap around 24 hours
        for (int i = startHour; i < endHour; i++) {
          timelineColors[i] = alarmColor;
        }
      } else {
        // Wrap around case
        for (int i = startHour; i < 24; i++) {
          timelineColors[i] = alarmColor;
        }
      }
    }
  }

  String startAlarmTime(AlarmModel alarm) {
    DateTime startTime = DateTime(
      0,
      0,
      0,
      alarm.alarmHour,
      alarm.alarmMinute,
    );
    Duration duration = Duration(
      hours: alarm.durationHour,
      minutes: alarm.durationMinute,
    );

    String startTimeFormatted =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    return startTimeFormatted;
  }

  String endAlarmTime(AlarmModel alarm) {
    DateTime startTime = DateTime(
      0,
      0,
      0,
      alarm.alarmHour,
      alarm.alarmMinute,
    );
    Duration duration = Duration(
      hours: alarm.durationHour,
      minutes: alarm.durationMinute,
    );
    DateTime endTime = startTime.add(duration);

    String endTimeFormatted =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    return endTimeFormatted;
  }

  // Helper function to convert hex color string to Color
  Color _hexToColor(String hex) {
    return Color(int.parse(hex));
  }

  @override
  Widget build(BuildContext context) {
    int firstAlarmIndex = 0; // Local variable to track the alarm index
    int secondAlarmIndex = 0; // Local variable to track the alarm index

    return Expanded(
      child: ListView.builder(
        itemCount: 23, // 24 hours in the timeline
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          // Ensure _generateTimelineColors is not repeatedly called during rendering
          _generateTimelineColors();

          List<Widget> rowWidgets = []; // List to hold widgets for each row

          if (position == 0 && widget.alarms.length == 0) {
            rowWidgets.add(
              Row(
                children: [
                  Text('00:00', style: weekHeaders),
                ],
              ),
            );
          } else if (position == 0 && position != widget.alarms[0].alarmHour) {
            rowWidgets.add(
              Row(
                children: [
                  Text('00:00', style: weekHeaders),
                ],
              ),
            );
          }

          if (position >= 0 && position <= 23) {
            for (var alarm in widget.alarms) {
              if (firstAlarmIndex < widget.alarms.length) {
                if (alarm.alarmHour == position) {
                  rowWidgets.add(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.theme
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
                                      startAlarmTime(alarm),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          int.parse(alarm.alarmColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Text(
                              startAlarmTime(alarm),
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(int.parse(alarm.alarmColor)),
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(int.parse(alarm.alarmColor)),
                                // Set the color based on the timeline array
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: _AlarmContents(alarm: alarm)),
                        // The second widget takes the remaining space
                      ],
                    ),
                  );
                  firstAlarmIndex++;
                }
              }
            }
          }

          // Add the dot for the hour
          rowWidgets.add(
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: timelineColors[
                position], // Set the color based on the timeline array
                shape: BoxShape.circle,
              ),
            ),
          );

          if (position >= 0 && position <= 23) {
            // Only access the alarm if the index is within bounds
            for (var alarm in widget.alarms) {
              int endHour = (alarm.alarmHour + alarm.durationHour) % 24;
              if (secondAlarmIndex < widget.alarms.length) {
                if (endHour == position + 1) {
                  print("NewTimeline endHour ${endHour}");
                  print("NewTimeline position ${position + 1}");
                  rowWidgets.add(
                    Row(
                      children: [
                        widget.theme
                            ? Text(endAlarmTime(alarm), style: weekHeaders)
                            : Text(
                          endAlarmTime(alarm),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(int.parse(alarm.alarmColor)),
                          ),
                        ),
                      ],
                    ),
                  );
                  secondAlarmIndex++;
                }
              }
            }
          }

          if (position == 22 && widget.alarms.length == 0) {
            rowWidgets.add(
              Row(
                children: [
                  Text('23:59', style: weekHeaders),
                ],
              ),
            );
          } else if (position == 22 &&
              position != widget.alarms.last.alarmHour) {
            rowWidgets.add(
              Row(
                children: [
                  Text('23:59', style: weekHeaders),
                ],
              ),
            );
          }

          // Return the row with the widgets
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowWidgets,
          );
        },
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
