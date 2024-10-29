import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class WheelPickerExample extends StatefulWidget {
  final Function(int hour, int minute)? onValueChanged; // Callback property

  const WheelPickerExample({this.onValueChanged}); // Constructor

  @override
  State<WheelPickerExample> createState() => _WheelPickerExampleState();
}

class _WheelPickerExampleState extends State<WheelPickerExample> {
  final now = TimeOfDay.now();
  int selectedHour = 0; // Track selected hour
  int selectedMinute = 0; // Track selected minute

  late final _hoursWheel = WheelPickerController(
    itemCount: 24,
    initialIndex: selectedHour,
  );
  late final _minutesWheel = WheelPickerController(
    itemCount: 60,
    initialIndex: selectedHour,
  );

  void _updateSelectedTime() {
    // Trigger onValueChanged callback if defined
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(selectedHour, selectedMinute);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 26.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!,
      squeeze: 1.25,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    Widget itemBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    final timeWheels = <Widget>[
      Expanded(
        child: WheelPicker(
          builder: itemBuilder,
          controller: _hoursWheel,
          looping: false,
          style: wheelStyle,
          selectedIndexColor: Colors.white,
          onIndexChanged: (index) {
            setState(() {
              selectedHour = index;
              _updateSelectedTime(); // Update when hour changes
            });
          },
        ),
      ),
      const Text(":", style: textStyle),
      Expanded(
        child: WheelPicker(
          builder: itemBuilder,
          controller: _minutesWheel,
          looping: true,
          style: wheelStyle,
          selectedIndexColor: Colors.white,
          onIndexChanged: (index) {
            setState(() {
              selectedMinute = index;
              _updateSelectedTime(); // Update when minute changes
            });
          },
        ),
      ),
    ];

    return Center(
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _centerBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: timeWheels,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoursWheel.dispose();
    _minutesWheel.dispose();
    super.dispose();
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Container(
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFC3C9FA).withAlpha(26),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
