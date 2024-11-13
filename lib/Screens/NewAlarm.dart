import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/AlarmMethods.dart';
import '../Components/CustomAppBar.dart';
import '../Components/SmartWheelPicker.dart';
import '../Components/SwitchState.dart';
import '../Components/WheelPicker.dart';
import '../Models/alarm_model.dart';
import '../constants.dart';

class NewAlarm extends StatefulWidget {
  final String selectedDay;

  const NewAlarm({super.key, required this.selectedDay});

  @override
  State<NewAlarm> createState() => _NewAlarmState();
}

class _NewAlarmState extends State<NewAlarm> {
  String alarmName = '';
  int selectedDurationHour = 0;
  int selectedDurationMinute = 0;
  int selectedAlarmHour = 0;
  int selectedAlarmMinute = 0;
  String selectedThemeColor = '';
  late DateTime selectedDateTime;
  int alarmId = 0;
  AlarmMethods alarms = AlarmMethods();
  bool theme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThemeValueFlag();
  }

  void stopAlarm(int? alarmId) {
    Alarm.stop(alarmId!);
  }

  Future<void> getThemeValueFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('selected_theme') != null) {
      setState(() {
        theme = prefs.getBool('selected_theme')!;
      });
    } else {
      setState(() {
        theme = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF007AFF),
                  size: 17,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          title: Text(
            'New Alarm',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                children: [
                  Text('Alarm name',
                      style: theme ? secondaryAlarmTextStyle : AlarmTextStyle),
                  SizedBox(height: 2),
                  TextField(
                    style: TextStyle(
                        color: theme ? Color(0xFFEEEEEE) : Color(0xFF1E1E1E),
                        fontSize: 16),
                    onChanged: (value) {
                      setState(() {
                        alarmName = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Meeting with...',
                    ),
                  ),
                  SizedBox(height: 23),
                  Text('Time',
                      style: theme ? secondaryAlarmTextStyle : AlarmTextStyle),
                  SizedBox(height: 6),
                  Container(
                    width: 199,
                    height: 77,
                    child: WheelPickerExample(
                      onValueChanged: (hour, minute) {
                        setState(() {
                          selectedAlarmHour = hour;
                          selectedAlarmMinute = minute;
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF0B0D9C),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF0B0D9C),
                            Color(0xFF9711B3),
                          ],
                        )),
                  ),
                  SizedBox(height: 44),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Temporary',
                              style:
                                  theme ? secondaryAppBarStyle : appBarStyle),
                          Text(
                            'You can set a one-time alarm. \nIt will only go off once',
                            style: secondaryTextColor,
                          ),
                        ],
                      ),
                      SwitchState(
                        activeColor: settingSwitch,
                        trackOutlineColor: settingSwitch,
                        thumbColor: (Colors.grey[300])!,
                        inActiveTrackColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 23),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration',
                          style: theme ? secondaryAlarmTextStyle : appBarStyle),
                      SizedBox(height: 8),
                      WheelPicker(
                        theme: theme,
                        onValueChanged: (hour, minute) {
                          setState(() {
                            selectedDurationHour = hour;
                            selectedDurationMinute = minute;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 23),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme',
                          style: theme ? secondaryAppBarStyle : appBarStyle),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          getTheme('0xFF1A2C68'),
                          SizedBox(width: 8),
                          getTheme('0xFF681A1A'),
                          SizedBox(width: 8),
                          getTheme('0xFF906818'),
                          SizedBox(width: 8),
                          getTheme('0xFF24801F'),
                          SizedBox(width: 8),
                          getTheme('0xFF751C66'),
                          SizedBox(width: 8),
                          getTheme('0xFF1C6675'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // The save button is now placed at the bottom
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('Save this alarm', style: buttonTextStyle),
                    onPressed: () async {
                      // Check if time and duration values are set
                      if (selectedAlarmHour != '' && selectedThemeColor != '') {
                        debugPrint('durationValue= ${selectedDurationHour}');
                        debugPrint('durationValue= ${selectedDurationMinute}');
                        debugPrint('durationValue= ${selectedAlarmHour}');
                        debugPrint('durationValue= ${selectedAlarmMinute}');
                        final box = Hive.box<AlarmModel>('alarm-db');

                        // Set default values for vibrate and volume
                        bool defaultVibrate = true;
                        double defaultVolume = 0.5;

                        if (box.isNotEmpty) {
                          // If there is at least one alarm, get the last alarm's vibrate and volume values
                          var lastAlarm = box.values.last;
                          defaultVibrate = lastAlarm.vibrate;
                          defaultVolume = lastAlarm.volume;

                          debugPrint(
                              'Last Alarm vibrate= ${lastAlarm.vibrate}');
                          debugPrint('Last Alarm volume= ${lastAlarm.volume}');
                        }

                        // Create an AlarmModel object with the input data
                        AlarmModel alarm = AlarmModel(
                          alarmId: alarmId + 1, // Set to null initially
                          alarmName:
                              alarmName.isEmpty ? 'Default Alarm' : alarmName,
                          alarmHour: selectedAlarmHour,
                          alarmMinute: selectedAlarmMinute,
                          durationHour: selectedDurationHour,
                          durationMinute: selectedDurationMinute,
                          alarmColor: selectedThemeColor,
                          alarmDay: widget.selectedDay,
                          isEnabled: true,
                          vibrate:
                              defaultVibrate, // Use the determined vibrate value
                          volume: defaultVolume,
                        );

                        alarmId = await box.add(alarm) + 1;

                        alarm.alarmId = alarmId;
                        alarm.save();
                        alarms.triggerAlarm();

                        // Optionally navigate back or show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Alarm saved successfully!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please set all alarm details.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAD022B),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                      minimumSize: Size(double.infinity, 57),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded getTheme(String colour) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedThemeColor = colour; // Set the selected color
          });
        },
        child: Container(
          height: 50,
          width: 50,
          child: Card(
            color: Color(int.parse(colour)),
            margin: EdgeInsets.all(5),
            shape: selectedThemeColor == colour
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black, width: 2),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
