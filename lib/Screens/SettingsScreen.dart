import 'package:alarm_clock/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Settings'), // Use the custom AppBar
        body: Center(
          child: Text('Settings screen content'),
        ),
      ),
    );
  }
}
