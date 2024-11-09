import 'package:alarm/alarm.dart';
import 'package:alarm_clock/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../Components/AlarmMethods.dart';
import '../Components/SwitchState.dart';
import '../Components/ThemeProvider.dart';
import '../Models/alarm_model.dart';
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double sound;
  late bool vibration;
  late bool dayOff;
  bool CalendorEvent = false;
  bool isLightInitialized = false; // Flag to check initialization
  AlarmMethods alarms = AlarmMethods();
  late final Box<AlarmModel> box;
  AlarmModel? alarm;
  bool theme = false;

  @override
  void initState() {
    super.initState();
    box = Hive.box<AlarmModel>('alarm-db');
    getThemeValueFlag();

    // Check if there are any items in the box before accessing index 0
    if (box.isNotEmpty) {
      alarm = box.getAt(0);
      vibration = alarm?.vibrate ??
          true; // Set `light` to `alarm.vibrate` or `true` if `vibrate` is null
      sound = alarm?.volume ?? 0.5;
      dayOff = alarm?.isEnabled == true
          ? false
          : true; // Set dayOff to false if isEnabled is true, otherwise true
      isLightInitialized = true;
    } else {
      // Set `light` to a default value if the box is empty
      vibration = true;
      sound = 0.5;
      dayOff = false;
      isLightInitialized = false;
    }
  }

  Future<void> setThemeValueFlag(bool theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('selected_theme', theme);
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Settings', theme: theme), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme',
                    style: theme ? secondaryAppBarStyle : appBarStyle,
                  ),
                  Switch(
                    // This bool value toggles the switch.
                    value: theme,
                    thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Icon(
                            Icons.sunny,
                            color: Color(0xFFF3A736),
                          ); // Return widget.thumbIcon directly
                        }
                        return Icon(
                          Icons.sunny,
                          color: Color(0xFFF3A736),
                        ); // Return thumbIcon for other states as well
                      },
                    ),
                    activeColor: settingSwitch,
                    inactiveTrackColor: Color(0xFF3A3A3A),
                    trackOutlineWidth: MaterialStateProperty.all(0.7),
                    thumbColor: MaterialStateProperty.all(Colors.grey[300]),
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.

                      setState(() {
                        theme = value;
                        themeProvider.toggleTheme(value);
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 31,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sound',
                    style: theme ? secondaryAppBarStyle : appBarStyle,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (sound <= 0.0) {
                              sound = 0.0;
                            } else {
                              sound -= 0.1;
                            }
                          });
                        },
                        child: Icon(Icons.remove,
                            color: theme ? Colors.white : Colors.black),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: Color(0xFFB6B3B3),
                            activeTrackColor: Color(0xFFFD0746),
                            thumbColor: Colors.white,
                            overlayColor: Color(0x29EB1555),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 28.0),
                          ),
                          child: Slider(
                            value: sound,
                            min: 0.0,
                            max: 1.0,
                            onChanged: isLightInitialized
                                ? (double newValue) async {
                                    setState(
                                      () {
                                        sound = newValue;
                                      },
                                    );
                                    // Update the `vibrate` field for all alarms
                                    final updatedSoundAlarms =
                                        box.values.map((alarm) {
                                      return alarm
                                        ..volume =
                                            sound; // Update vibrate based on switch state
                                    }).toList();

                                    // Clear the box and add all updated alarms back to it
                                    await box.clear();
                                    await box.addAll(updatedSoundAlarms);

                                    // Trigger alarm for all updated alarms
                                    for (var alarm in updatedSoundAlarms) {
                                      await alarms.triggerAlarm(alarm);
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              if (sound >= 1.0) {
                                sound = 1.0;
                              } else {
                                sound += 0.1;
                              }
                            },
                          );
                        },
                        child: Icon(Icons.add,
                            color: theme ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vibration',
                    style: theme ? secondaryAppBarStyle : appBarStyle,
                  ),
                  Switch(
                      // This bool value toggles the switch.
                      value: vibration,
                      activeColor: settingSwitch,
                      inactiveTrackColor:
                          theme ? Color(0xFF131313) : Colors.white,
                      activeTrackColor: settingSwitch,
                      trackOutlineWidth: MaterialStateProperty.all(0.7),
                      trackOutlineColor:
                          MaterialStateProperty.all(settingSwitch),
                      thumbColor: MaterialStateProperty.all(Colors.grey[300]),
                      onChanged: isLightInitialized
                          ? (bool value) async {
                              setState(() {
                                vibration = value;
                              });
                              // Update the `vibrate` field for all alarms
                              final updatedVibrateAlarms =
                                  box.values.map((alarm) {
                                return alarm
                                  ..vibrate =
                                      vibration; // Update vibrate based on switch state
                              }).toList();

                              // Clear the box and add all updated alarms back to it
                              await box.clear();
                              await box.addAll(updatedVibrateAlarms);

                              // Trigger alarm for all updated alarms
                              for (var alarm in updatedVibrateAlarms) {
                                await alarms.triggerAlarm(alarm);
                              }
                            }
                          : null),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calendor Event',
                        style: theme ? secondaryAppBarStyle : appBarStyle,
                      ),
                      Text(
                        'You can sync events \n from your device\'s calendar.',
                        style: secondaryTextColor,
                      ),
                    ],
                  ),
                  Switch(
                    value: CalendorEvent,
                    onChanged: (value) {
                      setState(() {
                        CalendorEvent = value;
                      });
                    },
                    activeTrackColor: settingSwitch,
                    activeColor: settingSwitch,
                    trackOutlineWidth: MaterialStateProperty.all(0.7),
                    trackOutlineColor: MaterialStateProperty.all(settingSwitch),
                    thumbColor: MaterialStateProperty.all(Colors.grey[300]),
                    inactiveTrackColor:
                        theme ? Color(0xFF131313) : Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day off',
                    style: theme ? secondaryAppBarStyle : appBarStyle,
                  ),
                  Switch(
                      // This bool value toggles the switch.
                      value: dayOff,
                      activeColor: settingSwitch,
                      inactiveTrackColor:
                          theme ? Color(0xFF131313) : Colors.white,
                      trackOutlineWidth: MaterialStateProperty.all(0.7),
                      trackOutlineColor:
                          MaterialStateProperty.all(settingSwitch),
                      activeTrackColor: settingSwitch,
                      thumbColor: MaterialStateProperty.all(Colors.grey[300]),
                      onChanged: isLightInitialized
                          ? (bool value) async {
                              setState(() {
                                dayOff = value;

                                final updatedDayOffAlarms =
                                    box.values.map((alarm) {
                                  return alarm
                                    ..isEnabled = value
                                        ? false
                                        : true; // Set isEnabled to false if dayOff is true, otherwise keep its current value
                                }).toList();
                                box.addAll(updatedDayOffAlarms);
                                for (var alarm in updatedDayOffAlarms) {
                                  Alarm.stop(alarm.alarmId);
                                  alarms.triggerAlarm(alarm);
                                }
                              });
                            }
                          : null),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
