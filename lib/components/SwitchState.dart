import 'package:flutter/material.dart';

class SwitchState extends StatefulWidget {
  SwitchState({
    required this.activeColor,
    required this.inActiveTrackColor,
    required this.trackOutlineColor,
    required this.thumbColor,
  });

  final Color activeColor;
  final Color inActiveTrackColor;
  final Color trackOutlineColor;
  final Color thumbColor;

  @override
  State<SwitchState> createState() => _SwitchStateState();
}

class _SwitchStateState extends State<SwitchState> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: widget.activeColor,
      inactiveTrackColor: widget.inActiveTrackColor,
      trackOutlineWidth: MaterialStateProperty.all(0.7),
      trackOutlineColor: MaterialStateProperty.all(widget.trackOutlineColor),
      thumbColor: MaterialStateProperty.all(widget.thumbColor),
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
