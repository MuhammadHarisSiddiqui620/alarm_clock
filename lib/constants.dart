import 'package:flutter/material.dart';

const appBarStyle =
    TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Roboto');

const dayHeader =
    TextStyle(fontSize: 21, color: Colors.black, fontFamily: 'Roboto');

const dayContainer =
    TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Roboto');

const secondaryTextColor =
    TextStyle(fontSize: 12, color: Color(0xFF585858), fontFamily: 'Roboto');

const weekHeaders =
    TextStyle(fontSize: 12, color: Color(0xFF8F8F8F), fontFamily: 'Roboto');

const dayContainerTimer =
    TextStyle(fontSize: 35, color: Colors.white, fontFamily: 'Roboto');

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

const buttonTextStyle =
    TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Roboto');

const newAlarmTextStyle =
    TextStyle(color: Color(0xFF313131), fontSize: 12, fontFamily: 'Roboto');

const weekWheelerText =
    TextStyle(color: Color(0xFF007AFF), fontSize: 17, fontFamily: 'Roboto');

const bottomSheetText =
    TextStyle(color: Color(0xFF212121), fontSize: 17, fontFamily: 'Roboto');

const bottomSheetTexts =
    TextStyle(color: Color(0xFF3A3A3A), fontSize: 16, fontFamily: 'Roboto');

const bottomSheetTextheader = TextStyle(
    color: Color(0xFF3A3A3A),
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold);

const List<Widget> _widgetOptions = <Widget>[
  Text(
    'Index 0: Day',
    style: optionStyle,
  ),
  Text(
    'Index 1: Alarms',
    style: optionStyle,
  ),
  Text(
    'Index 2: Week',
    style: optionStyle,
  ),
  Text(
    'Index 3: Settings',
    style: optionStyle,
  ),
];

const List<Color> alarmColor = [
  Color(0xFF4869DD),
  Color(0xFFDD4848),
  Color(0xFFF3A736),
  Color(0xFF4AE352),
  Color(0xFFE452E4),
  Color(0xFF52E2E4),
  Color(0xFF999999),
  Color(0xFF3A3A3A),
];

const Color settingSwitch = Color(0xFFAD022B);
