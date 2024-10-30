import 'package:alarm_clock/Components/CustomAppBar.dart';
import 'package:alarm_clock/Components/TimelineStatusPage.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Week'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 27),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the content vertically
            children: [
              // Horizontal ListView for days of the week
              Container(
                height: 50,
                margin: EdgeInsets.only(
                    left: screenWidth * 0.5 -
                        50), // 50% of screen width minus half the container width (75)
                child: ListView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Monday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Tuesday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Wednesday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Thursday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Friday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Saturday',
                        style: appBarStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Sunday',
                        style: appBarStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TimelineStatusPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
