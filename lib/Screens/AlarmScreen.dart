import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Alarms'), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25),
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
                // Use Expanded to center the content in the remaining space
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/no-alarm.svg', // Directly using SvgPicture
                        width: 100, // Optional: Set a width for the SVG
                        height: 100, // Optional: Set a height for the SVG
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Text('You haven’t created alarms', style: appBarStyle),
                    ],
                  ),
                ),
              ),
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
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          )),
                      onPressed: () {},
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
}
