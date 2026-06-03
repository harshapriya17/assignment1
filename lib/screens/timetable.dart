import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/study_session.dart';
import '../models/subject.dart';
import '../providers/study_provider.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  
  String selectedDay = 'Monday';
  Subject? selectedSubject;
  TimeOfDay startTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 21, minute: 0);
  final TextEditingController topicController = TextEditingController();

  void _showSessionDialog(StudyProvider studyProvider, {StudySession? session}) {
    if (session != null) {
      topicController.text = session.topic;
      selectedDay = session.day;
      selectedSubject = studyProvider.subjects.firstWhere((s) => s.id == session.subjectId, orElse: () => studyProvider.subjects.first);
      startTime = session.startTime;
      endTime = session.endTime;
    } else {
      topicController.clear();
      selectedSubject = studyProvider.subjects.isNotEmpty ? studyProvider.subjects.first : null;
      startTime = const TimeOfDay(hour: 19, minute: 0);
      endTime = const TimeOfDay(hour: 21, minute: 0);
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(session == null ? "Plan Study Session" : "Edit Session", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: _inputDecoration("Day"),
                items: days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) => setModalState(() => selectedDay = val!),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<Subject>(
                value: selectedSubject,
                decoration: _inputDecoration("Subject"),
                items: studyProvider.subjects.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                onChanged: (val) => setModalState(() => selectedSubject = val),
              ),
              const SizedBox(height: 15),
              TextField(controller: topicController, decoration: _inputDecoration("Topic (Optional)")),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(context: context, initialTime: startTime);
                        if (time != null) setModalState(() => startTime = time);
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text("Start: ${startTime.format(context)}"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(context: context, initialTime: endTime);
                        if (time != null) setModalState(() => endTime = time);
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text("End: ${endTime.format(context)}"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
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
                    if (selectedSubject == null) return;
                    if (session == null) {
                      final newSession = StudySession(
                        id: DateTime.now().millisecondsSinceEpoch,
                        subjectId: selectedSubject!.id,
                        day: selectedDay,
                        startHour: startTime.hour,
                        startMinute: startTime.minute,
                        endHour: endTime.hour,
                        endMinute: endTime.minute,
                        topic: topicController.text,
                      );
                      studyProvider.addSession(newSession);
                    } else {
                      session.subjectId = selectedSubject!.id;
                      session.day = selectedDay;
                      session.startHour = startTime.hour;
                      session.startMinute = startTime.minute;
                      session.endHour = endTime.hour;
                      session.endMinute = endTime.minute;
                      session.topic = topicController.text;
                      studyProvider.updateSession(session);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(session == null ? "Add to Timetable" : "Update Session", style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
  );

  @override
  Widget build(BuildContext context) {
    final studyProvider = Provider.of<StudyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Study Timetable", style: TextStyle(fontWeight: FontWeight.bold))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSessionDialog(studyProvider),
        icon: const Icon(Icons.add),
        label: const Text("Add Session"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final daySessions = studyProvider.sessions.where((s) => s.day == day).toList();
          
          if (daySessions.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(day.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
              ),
              ...daySessions.map((session) => _buildSessionCard(context, studyProvider, session)),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, StudyProvider studyProvider, StudySession session) {
    final subject = studyProvider.subjects.firstWhere(
      (s) => s.id == session.subjectId,
      orElse: () => Subject(id: 0, name: "Deleted", color: "ff808080", targetHours: 0),
    );
    final color = Color(int.parse(subject.color, radix: 16));

    return Dismissible(
      key: ValueKey(session.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => studyProvider.deleteSession(session),
      child: GestureDetector(
        onTap: () => _showSessionDialog(studyProvider, session: session),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(width: 5, height: 60, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${session.startTime.format(context)} - ${session.endTime.format(context)}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    if (session.topic.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text("Topic: ${session.topic}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
