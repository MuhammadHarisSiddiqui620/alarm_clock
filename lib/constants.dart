import 'package:flutter/material.dart';

const appBarStyle =
    TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Roboto');

const dayHeader =
    TextStyle(fontSize: 21, color: Colors.black, fontFamily: 'Roboto');

const dayContainer =
    TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Roboto');

const dayContainerTimer =
    TextStyle(fontSize: 35, color: Colors.white, fontFamily: 'Roboto');

const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
