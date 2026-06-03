import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/subject.dart';
import '../providers/study_provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController titleController = TextEditingController();
  Subject? selectedSubject;
  DateTime selectedDate = DateTime.now();
  String selectedPriority = 'Medium';

  void _showTaskDialog(StudyProvider studyProvider, {Task? task}) {
    if (task != null) {
      titleController.text = task.title;
      selectedSubject = studyProvider.subjects.firstWhere((s) => s.id == task.subjectId, orElse: () => studyProvider.subjects.first);
      selectedDate = task.deadline;
      selectedPriority = task.priority;
    } else {
      titleController.clear();
      selectedSubject = studyProvider.subjects.isNotEmpty ? studyProvider.subjects.first : null;
      selectedDate = DateTime.now();
      selectedPriority = 'Medium';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task == null ? "Add New Task" : "Edit Task",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Task Title",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<Subject>(
                value: selectedSubject,
                decoration: InputDecoration(
                  labelText: "Subject",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: studyProvider.subjects.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s.name));
                }).toList(),
                onChanged: (val) => setModalState(() => selectedSubject = val),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setModalState(() => selectedDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('dd MMM, yyyy').format(selectedDate)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: InputDecoration(
                        labelText: "Priority",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ['Low', 'Medium', 'High'].map((p) {
                        return DropdownMenuItem(value: p, child: Text(p));
                      }).toList(),
                      onChanged: (val) => setModalState(() => selectedPriority = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    if (titleController.text.isEmpty || selectedSubject == null) return;
                    
                    if (task == null) {
                      final newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: titleController.text,
                        subjectId: selectedSubject!.id,
                        deadline: selectedDate,
                        priority: selectedPriority,
                      );
                      studyProvider.addTask(newTask);
                    } else {
                      task.title = titleController.text;
                      task.subjectId = selectedSubject!.id;
                      task.deadline = selectedDate;
                      task.priority = selectedPriority;
                      studyProvider.updateTask(task);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(task == null ? "Create Task" : "Update Task", style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = Provider.of<StudyProvider>(context);
    final pendingTasks = studyProvider.tasks.where((t) => !t.completed).toList();
    final completedTasks = studyProvider.tasks.where((t) => t.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(studyProvider),
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader("Pending Tasks", pendingTasks.length),
                const SizedBox(height: 15),
                if (pendingTasks.isEmpty)
                  _buildEmptyState("No pending tasks! 🎉")
                else
                  ...pendingTasks.map((task) => _buildTaskItem(context, studyProvider, task)),
                
                const SizedBox(height: 30),
                _buildHeader("Completed", completedTasks.length),
                const SizedBox(height: 15),
                ...completedTasks.map((task) => _buildTaskItem(context, studyProvider, task)),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, StudyProvider studyProvider, Task task) {
    final subject = studyProvider.subjects.firstWhere(
      (s) => s.id == task.subjectId,
      orElse: () => Subject(id: 0, name: "Unknown", color: "ff808080", targetHours: 0),
    );
    final subjectColor = Color(int.parse(subject.color, radix: 16));

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => studyProvider.deleteTask(task),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _showTaskDialog(studyProvider, task: task),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: task.completed,
                activeColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onChanged: (_) => studyProvider.toggleTaskStatus(task),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                      color: task.completed ? Colors.grey : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: subjectColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subject.name,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_month, size: 14, color: _getDateColor(task.deadline)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM').format(task.deadline),
                        style: TextStyle(
                          fontSize: 13,
                          color: _getDateColor(task.deadline),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildPriorityIndicator(task.priority),
          ],
        ),
      ),
    ),
  );
}

  Color _getDateColor(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadline = DateTime(date.year, date.month, date.day);
    
    if (deadline.isBefore(today)) return Colors.red;
    if (deadline.isAtSameMomentAs(today)) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'High': color = Colors.red; break;
      case 'Medium': color = Colors.orange; break;
      default: color = Colors.blue;
    }
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
