import 'package:alarm_clock/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool theme;

  const CustomAppBar({Key? key, required this.title, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: theme ? secondaryAppBarStyle : appBarStyle,
      ),
      elevation: 0.0, // Optional: Remove the AppBar shadow
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
