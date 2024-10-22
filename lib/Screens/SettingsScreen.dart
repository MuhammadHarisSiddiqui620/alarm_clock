import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../components/SwitchState.dart';
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int height = 50;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Settings'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme',
                    style: appBarStyle,
                  ),
                  SwitchState(
                    activeColor: settingSwitch,
                    trackOutlineColor: settingSwitch,
                    thumbColor: (Colors.grey[300])!,
                    inActiveTrackColor: Colors.white,
                  ),
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
                    style: appBarStyle,
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
                            if (height <= 0) {
                              height = 0;
                            } else {
                              height -= 1;
                            }
                          });
                        },
                        child: Icon(Icons.remove, color: Colors.black),
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
                            value: height.toDouble(),
                            min: 0.0,
                            max: 100.0,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (height >= 100) {
                              height = 100;
                            } else {
                              height += 1;
                            }
                          });
                        },
                        child: Icon(Icons.add, color: Colors.black),
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
                    style: appBarStyle,
                  ),
                  SwitchState(
                    activeColor: settingSwitch,
                    trackOutlineColor: settingSwitch,
                    thumbColor: (Colors.grey[300])!,
                    inActiveTrackColor: Colors.white,
                  ),
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
                        style: appBarStyle,
                      ),
                      Text(
                        'You can sync events \n from your device\'s calendar.',
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
              SizedBox(
                height: 31,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day off',
                    style: appBarStyle,
                  ),
                  SwitchState(
                    activeColor: settingSwitch,
                    trackOutlineColor: settingSwitch,
                    thumbColor: (Colors.grey[300])!,
                    inActiveTrackColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
