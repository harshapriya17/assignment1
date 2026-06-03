import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studyProvider = Provider.of<StudyProvider>(context);
    final completedTasks = studyProvider.tasks.where((t) => t.completed).length;
    final totalTasks = studyProvider.tasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Progress", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weekly Insights",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            
            _buildChartContainer(context),
            
            const SizedBox(height: 30),
            
            const Text(
              "General Statistics",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 13),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    context,
                    "Total Tasks",
                    totalTasks.toString(),
                    Icons.task_alt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile(
                    context,
                    "Completed",
                    completedTasks.toString(),
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            
            _buildStatTile(
              context,
              "Task Completion Rate",
              "${(progress * 100).toStringAsFixed(1)}%",
              Icons.trending_up,
              Colors.orange,
              isWide: true,
            ),
            
            const SizedBox(height: 15),
            
            _buildStatTile(
              context,
              "Study Streak",
              "7 Days 🔥",
              Icons.local_fire_department,
              Colors.red,
              isWide: true,
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Study Hours", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Last 7 Days", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 25),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(days[value.toInt() % 7], style: const TextStyle(color: Colors.grey, fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroup(0, 5, context),
                  _makeGroup(1, 8, context),
                  _makeGroup(2, 4, context),
                  _makeGroup(3, 7, context),
                  _makeGroup(4, 9, context),
                  _makeGroup(5, 6, context),
                  _makeGroup(6, 3, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroup(int x, double y, BuildContext context) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Theme.of(context).primaryColor,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Theme.of(context).primaryColor.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
