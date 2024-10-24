import 'package:alarm_clock/constants.dart';
import 'package:flutter/material.dart';

class WheelPicker extends StatefulWidget {
  @override
  _WheelPickerState createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  final List<String> hours =
      List<String>.generate(24, (i) => i.toString().padLeft(2, '0'));
  final List<String> minutes =
      List<String>.generate(60, (i) => i.toString().padLeft(2, '0'));

  String selectedHour = "00";
  String selectedMinute = "00";

  // Scroll controllers
  FixedExtentScrollController hourController = FixedExtentScrollController();
  FixedExtentScrollController minuteController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour Wheel
        Container(
          width: 43,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListWheelScrollView.useDelegate(
            controller: hourController,
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedHour = hours[index];
              });
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    hours[index],
                    style: weekWheelerText,
                  ),
                );
              },
              childCount: hours.length,
            ),
          ),
        ),
        SizedBox(width: 8), // Spacer between hour and minute
        Text('H',
            style: TextStyle(fontSize: 16, color: Colors.black)), // Hour label

        SizedBox(width: 8), // Spacer between hour and minute

        Text(':', style: TextStyle(fontSize: 24)),

        SizedBox(width: 8), // Spacer between hour and minute

        // Minute Wheel
        Container(
          width: 43,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListWheelScrollView.useDelegate(
            controller: minuteController,
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedMinute = minutes[index];
              });
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    minutes[index],
                    style: weekWheelerText,
                  ),
                );
              },
              childCount: minutes.length,
            ),
          ),
        ),
        SizedBox(width: 8), // Spacer between minute and label
        Text('M',
            style:
                TextStyle(fontSize: 16, color: Colors.black)), // Minute label
      ],
    );
  }
}
