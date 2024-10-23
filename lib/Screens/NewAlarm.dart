import 'package:flutter/material.dart';

import '../components/CustomAppBar.dart';
import '../components/SwitchState.dart';
import '../components/WheelPicker.dart';
import '../constants.dart';

class NewAlarm extends StatefulWidget {
  const NewAlarm({super.key});

  @override
  State<NewAlarm> createState() => _NewAlarmState();
}

class _NewAlarmState extends State<NewAlarm> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'New alarm'),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alarm name', style: newAlarmTextStyle),
              SizedBox(
                height: 2,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Meeting with',
                ),
              ),
              SizedBox(
                height: 23,
              ),
              Text('Time', style: newAlarmTextStyle),
              SizedBox(
                height: 6,
              ),
              Container(
                width: 199,
                height: 77,
                child: WheelPickerExample(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF9711B3),
                ),
              ),
              SizedBox(
                height: 44,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temporary',
                        style: appBarStyle,
                      ),
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
              SizedBox(
                height: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
