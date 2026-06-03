import 'package:hive_flutter/hive_flutter.dart';
import '../models/subject.dart';
import '../models/task.dart';
import '../models/study_session.dart';
import '../models/study_goal.dart';
import '../core/constants.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(StudySessionAdapter());
    Hive.registerAdapter(StudyGoalAdapter());

    // Open Boxes
    await Hive.openBox<Subject>(AppConstants.subjectBox);
    await Hive.openBox<Task>(AppConstants.taskBox);
    await Hive.openBox<StudySession>(AppConstants.sessionBox);
    await Hive.openBox<StudyGoal>(AppConstants.goalBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  static Box<Subject> getSubjectBox() => Hive.box<Subject>(AppConstants.subjectBox);
  static Box<Task> getTaskBox() => Hive.box<Task>(AppConstants.taskBox);
  static Box<StudySession> getSessionBox() => Hive.box<StudySession>(AppConstants.sessionBox);
  static Box<StudyGoal> getGoalBox() => Hive.box<StudyGoal>(AppConstants.goalBox);
  static Box getSettingsBox() => Hive.box(AppConstants.settingsBox);

  static Future<void> clearAllData() async {
    await getSubjectBox().clear();
    await getTaskBox().clear();
    await getSessionBox().clear();
    await getGoalBox().clear();
    // Keep settingsBox or clear as well? 
    // Usually Reset Data means user data, not necessarily theme settings.
  }
}
