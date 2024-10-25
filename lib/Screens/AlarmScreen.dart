import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import 'NewAlarm.dart'; // Your constants file

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // Track the selected day (e.g., Monday, Tuesday)
  String selectedDay = 'Monday';

  // Dummy alarm data for each day of the week
  Map<String, List<String>> alarms = {
    'Monday': ['07:00 AM - Meeting', '09:30 AM - Workout'],
    'Tuesday': [],
    'Wednesday': ['06:00 AM - Yoga'],
    'Thursday': ['07:30 AM - Call'],
    'Friday': [],
    'Saturday': ['08:00 AM - Gym'],
    'Sunday': []
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the list of alarms for the selected day
    List<String> selectedDayAlarms = alarms[selectedDay]!;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Alarms'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Horizontal ListView for days of the week
              Container(
                height: 50,
                margin: EdgeInsets.only(
                    left: screenWidth * 0.5 - 50), // 50% of screen width
                child: ListView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  children: [
                    getDayWidget('Monday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Tuesday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Wednesday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Thursday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Friday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Saturday'),
                    SizedBox(
                      width: 20,
                    ),
                    getDayWidget('Sunday'),
                  ],
                ),
              ),

              // Display alarms for the selected day
              Expanded(
                child: selectedDayAlarms.isEmpty
                    ? Center(
                        // No alarms for this day, show message
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/no-alarm.svg',
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 21),
                            Text('You haven’t created alarms',
                                style: appBarStyle),
                          ],
                        ),
                      )
                    : ListView.builder(
                        // Show list of alarms if there are any
                        itemCount: selectedDayAlarms.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(selectedDayAlarms[index],
                                style: appBarStyle),
                            leading:
                                Icon(Icons.alarm, color: Colors.deepPurple),
                          );
                        },
                      ),
              ),

              // Add new alarm button, only show if alarms exist for the day
              Container(
                margin: EdgeInsets.only(right: 16, bottom: 29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9711B3),
                        minimumSize: Size(172, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the NewAlarmScreen when the button is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewAlarm()),
                        );
                      },
                      child: Wrap(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Add new alarm',
                                style: buttonTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for each day button in the horizontal list
  GestureDetector getDayWidget(String day) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          day,
          style: TextStyle(
            color: selectedDay == day ? Color(0xFF131313) : Color(0xFF7E7E7E),
            fontFamily: 'Roboto',
            fontSize: selectedDay == day ? 17 : 17,
          ),
        ),
      ),
    );
  }
}
