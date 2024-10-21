import 'package:alarm_clock/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: appBarStyle,
        ),
      ),
      elevation: 0.0, // Optional: Remove the AppBar shadow
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
