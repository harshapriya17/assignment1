import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 0)
class Subject extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String color;

  @HiveField(3)
  int targetHours;

  Subject({
    required this.id,
    required this.name,
    required this.color,
    required this.targetHours,
  });
}
