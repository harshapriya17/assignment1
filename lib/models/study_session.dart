import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'study_session.g.dart';

@HiveType(typeId: 2)
class StudySession extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int subjectId;

  @HiveField(2)
  String day;

  @HiveField(3)
  int startHour;

  @HiveField(4)
  int startMinute;

  @HiveField(5)
  int endHour;

  @HiveField(6)
  int endMinute;

  @HiveField(7)
  String topic;

  StudySession({
    required this.id,
    required this.subjectId,
    required this.day,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.topic = '',
  });

  TimeOfDay get startTime => TimeOfDay(hour: startHour, minute: startMinute);
  TimeOfDay get endTime => TimeOfDay(hour: endHour, minute: endMinute);
}
