import 'package:flutter/material.dart';

class SwitchState extends StatefulWidget {
  const SwitchState({super.key});

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
      activeColor: Colors.grey[300],
      inactiveTrackColor: Colors.white,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
