import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String? alarmName;

  @HiveField(1)
  final int? alarmHour;

  @HiveField(2)
  final int? alarmMinute;

  @HiveField(3)
  final int? durationHour;

  @HiveField(4)
  final int? durationMinute;

  @HiveField(5)
  final String? alarmColor;

  @HiveField(6)
  final String? alarmDay; // New property to store the day

  AlarmModel({
    required this.alarmName,
    required this.alarmHour,
    required this.alarmMinute,
    required this.durationHour,
    required this.durationMinute,
    required this.alarmColor,
    required this.alarmDay,
  });
}
