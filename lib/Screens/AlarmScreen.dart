import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/CustomAppBar.dart';
import '../Components/Reusable_Alarm.dart';
import '../Models/alarm_model.dart';
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

  // Store all alarms for the selected day
  List<AlarmModel> alarms = [];
  // Controller for the ListWheelScrollView
  late FixedExtentScrollController _scrollController;

  // List of days of the week
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  bool theme = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 0);
    _loadAlarms(); // Load alarms from Hive
    getThemeValueFlag();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register this screen with the RouteObserver
    ModalRoute.of(context)!.addScopedWillPopCallback(_onPop);
  }

  Future<bool> _onPop() async {
    await _loadAlarms();
    return true;
  }

  Future<void> _loadAlarms() async {
    var box = Hive.box<AlarmModel>('alarm-db');
    DateTime now = DateTime.now();

    setState(() {
      alarms =
          box.values.where((alarm) => alarm.alarmDay == selectedDay).toList();

      // Sort by time, placing alarms after the current time first
      alarms.sort((a, b) {
        int aTime = a.alarmHour * 60 + a.alarmMinute;
        int bTime = b.alarmHour * 60 + b.alarmMinute;
        int currentTime = now.hour * 60 + now.minute;

        bool aIsAfterNow = aTime >= currentTime;
        bool bIsAfterNow = bTime >= currentTime;

        if (aIsAfterNow && !bIsAfterNow) return -1;
        if (!aIsAfterNow && bIsAfterNow) return 1;

        return aTime.compareTo(bTime);
      });
    });
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

  Future<void> _navigateToNewAlarm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewAlarm(selectedDay: selectedDay),
      ),
    );
    // Refresh alarms when coming back to AlarmScreen
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    // Get alarms for the selected day
    List<AlarmModel> selectedDayAlarms = alarms.toList();

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Alarms', theme: theme), // Use the custom AppBar
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Horizontal ListView for days of the week
              SizedBox(
                height: 25,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 120,
                    physics: FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDay = daysOfWeek[index];
                        _loadAlarms();
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Center(
                          child: RotatedBox(
                            quarterTurns: -3,
                            child: Text(
                              daysOfWeek[index],
                              style: TextStyle(
                                color: selectedDay == daysOfWeek[index]
                                    ? theme
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF131313)
                                    : Color(0xFF7E7E7E),
                                fontFamily: 'Roboto',
                                fontSize: 17,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: daysOfWeek.length,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Display alarms for the selected day
              Expanded(
                child: RefreshIndicator(
                    color: Colors.black,
                    backgroundColor: Color(0xFF0F0F0F0),
                    child: selectedDayAlarms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'images/no-alarm.svg',
                                  width: 100,
                                  height: 100,
                                  color: theme ? Colors.white : Colors.black,
                                ),
                                SizedBox(height: 21),
                                Text('You haven’t created alarms',
                                    style: theme
                                        ? secondaryAppBarStyle
                                        : appBarStyle),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: selectedDayAlarms.length,
                            itemBuilder: (context, index) {
                              final alarm = selectedDayAlarms[index];
                              return ReusableAlarm(
                                alarm: alarm,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 20);
                            },
                          ),
                    onRefresh: _loadAlarms),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF9711B3),
                              Color(0xFF0B0D9C),
                            ],
                          ),
                        ),
                        width: 172,
                        height: 50,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(172, 50),
                          backgroundColor: Colors
                              .transparent, // make button background transparent
                          shadowColor:
                              Colors.transparent, // remove button shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _navigateToNewAlarm,
                        child: Row(
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
                              style: buttonTextStyle.copyWith(
                                  color: Colors
                                      .white), // ensure text color is white
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
