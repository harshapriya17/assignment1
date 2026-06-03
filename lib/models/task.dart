import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int subjectId;

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
  bool completed;

  @HiveField(5)
  String priority; // High, Medium, Low

  Task({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.deadline,
    this.completed = false,
    this.priority = 'Medium',
  });
}
