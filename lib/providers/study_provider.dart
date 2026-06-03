import 'package:flutter/material.dart';
import '../database/hive_service.dart';
import '../models/subject.dart';
import '../models/task.dart';
import '../models/study_session.dart';
import '../models/study_goal.dart';

class StudyProvider extends ChangeNotifier {
  List<Subject> _subjects = [];
  List<Task> _tasks = [];
  List<StudySession> _sessions = [];
  StudyGoal? _todayGoal;

  List<Subject> get subjects => _subjects;
  List<Task> get tasks => _tasks;
  List<StudySession> get sessions => _sessions;
  StudyGoal? get todayGoal => _todayGoal;

  StudyProvider() {
    _loadData();
  }

  void _loadData() {
    _subjects = HiveService.getSubjectBox().values.toList();
    _tasks = HiveService.getTaskBox().values.toList();
    _sessions = HiveService.getSessionBox().values.toList();
    _loadTodayGoal();
    notifyListeners();
  }

  void _loadTodayGoal() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _todayGoal = HiveService.getGoalBox().values.firstWhere(
      (goal) => goal.date == today,
      orElse: () {
        final newGoal = StudyGoal(date: today);
        HiveService.getGoalBox().add(newGoal);
        return newGoal;
      },
    );
  }

  // Subject Methods
  Future<void> addSubject(Subject subject) async {
    await HiveService.getSubjectBox().add(subject);
    _subjects.add(subject);
    notifyListeners();
  }

  Future<void> updateSubject(int index, Subject subject) async {
    await HiveService.getSubjectBox().putAt(index, subject);
    _subjects[index] = subject;
    notifyListeners();
  }

  Future<void> deleteSubject(int index) async {
    final subject = _subjects[index];
    // Also delete tasks and sessions related to this subject
    final tasksToDelete = HiveService.getTaskBox().values.where((t) => t.subjectId == subject.id).toList();
    for (var task in tasksToDelete) {
      await task.delete();
    }
    final sessionsToDelete = HiveService.getSessionBox().values.where((s) => s.subjectId == subject.id).toList();
    for (var session in sessionsToDelete) {
      await session.delete();
    }
    
    await subject.delete();
    _subjects.removeAt(index);
    _tasks = HiveService.getTaskBox().values.toList();
    _sessions = HiveService.getSessionBox().values.toList();
    notifyListeners();
  }

  // Task Methods
  Future<void> addTask(Task task) async {
    await HiveService.getTaskBox().add(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> toggleTaskStatus(Task task) async {
    task.completed = !task.completed;
    await task.save();
    
    // Update goal if it's today
    if (_todayGoal != null) {
      if (task.completed) {
        _todayGoal!.completedTasks++;
      } else {
        _todayGoal!.completedTasks--;
      }
      await _todayGoal!.save();
    }
    
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
    _tasks.remove(task);
    notifyListeners();
  }

  // Session Methods
  Future<void> addSession(StudySession session) async {
    await HiveService.getSessionBox().add(session);
    _sessions.add(session);
    notifyListeners();
  }

  Future<void> updateSession(StudySession session) async {
    await session.save();
    notifyListeners();
  }

  Future<void> deleteSession(StudySession session) async {
    await session.delete();
    _sessions.remove(session);
    notifyListeners();
  }

  // Goal Methods
  Future<void> updateDailyGoal({double? hours, int? tasksCount}) async {
    if (_todayGoal != null) {
      if (hours != null) _todayGoal!.targetHours = hours;
      if (tasksCount != null) _todayGoal!.targetTasks = tasksCount;
      await _todayGoal!.save();
      notifyListeners();
    }
  }
  
  // Refresh data (e.g. after reset)
  void refresh() {
    _loadData();
  }
}
