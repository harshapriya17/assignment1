import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/study_provider.dart';
import '../widgets/app_background.dart';
import 'settings.dart';
import 'statistics.dart';
import 'subjects.dart';
import 'tasks.dart';
import 'timetable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const DashboardPage(),
    const SubjectsPage(),
    const TimetablePage(),
    const TasksPage(),
    const StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(child: pages[currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: "Subjects"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "Stats"),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final studyProvider = Provider.of<StudyProvider>(context);
    
    final int subjectCount = studyProvider.subjects.length;
    final int taskCount = studyProvider.tasks.where((t) => !t.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Keep up the great work! ✨",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 25),

            // PROGRESS CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Daily Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 12,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("65% of today's goals completed", style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: buildCard(
                    context,
                    "Subjects",
                    subjectCount.toString(),
                    Icons.book_rounded,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: buildCard(
                    context,
                    "Pending Tasks",
                    taskCount.toString(),
                    Icons.assignment_rounded,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _buildStreakCard(context, isDark),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                    ? [const Color(0xff4F46E5), const Color(0xff7C3AED)]
                    : [Theme.of(context).primaryColor, const Color(0xff818CF8)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Motivational Quote 💡", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    "\"The secret of getting ahead is getting started.\"",
                    style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning 👋";
    if (hour < 17) return "Good Afternoon 👋";
    return "Good Evening 👋";
  }

  Widget _buildStreakCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Current Streak", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                "7 Days 🔥",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
