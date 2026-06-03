// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyGoalAdapter extends TypeAdapter<StudyGoal> {
  @override
  final int typeId = 3;

  @override
  StudyGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyGoal(
      date: fields[0] as DateTime,
      targetHours: fields[1] as double,
      targetTasks: fields[2] as int,
      completedHours: fields[3] as double,
      completedTasks: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudyGoal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.targetHours)
      ..writeByte(2)
      ..write(obj.targetTasks)
      ..writeByte(3)
      ..write(obj.completedHours)
      ..writeByte(4)
      ..write(obj.completedTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
