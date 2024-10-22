import 'package:flutter/material.dart';

import '../components/CustomAppBar.dart';
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
              SizedBox(
                height: 77,
                width: 199,
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Color(0xFF9711B3),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: EdgeInsets.all(25.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
