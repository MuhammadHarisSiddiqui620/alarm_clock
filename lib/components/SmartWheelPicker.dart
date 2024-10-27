import 'package:alarm_clock/constants.dart';
import 'package:flutter/material.dart';

class WheelPicker extends StatefulWidget {
  final Function(int hour, int minute)? onValueChanged; // New callback property

  WheelPicker({this.onValueChanged}); // Constructor update

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

  void _onSelectedItemChanged() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(
          int.parse(selectedHour), int.parse(selectedMinute));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                _onSelectedItemChanged();
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
        SizedBox(width: 8),
        Text('H', style: TextStyle(fontSize: 16, color: Colors.black)),

        SizedBox(width: 15),

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
                _onSelectedItemChanged();
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
        SizedBox(width: 8),
        Text('M', style: TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }
}
