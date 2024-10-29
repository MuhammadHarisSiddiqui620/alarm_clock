// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmModelAdapter extends TypeAdapter<AlarmModel> {
  @override
  final int typeId = 0;

  @override
  AlarmModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmModel(
      alarmName: fields[0] as String?,
      alarmHour: fields[1] as int?,
      alarmMinute: fields[2] as int?,
      durationHour: fields[3] as int?,
      durationMinute: fields[4] as int?,
      alarmColor: fields[5] as String?,
      alarmDay: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.alarmName)
      ..writeByte(1)
      ..write(obj.alarmHour)
      ..writeByte(2)
      ..write(obj.alarmMinute)
      ..writeByte(3)
      ..write(obj.durationHour)
      ..writeByte(4)
      ..write(obj.durationMinute)
      ..writeByte(5)
      ..write(obj.alarmColor)
      ..writeByte(6)
      ..write(obj.alarmDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}