import 'package:hive/hive.dart';

part 'study_goal.g.dart';

@HiveType(typeId: 3)
class StudyGoal extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double targetHours;

  @HiveField(2)
  int targetTasks;

  @HiveField(3)
  double completedHours;

  @HiveField(4)
  int completedTasks;

  StudyGoal({
    required this.date,
    this.targetHours = 0,
    this.targetTasks = 0,
    this.completedHours = 0,
    this.completedTasks = 0,
  });
}
