import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/study_provider.dart';
import '../database/hive_service.dart';

import '../widgets/app_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider =
    Provider.of<ThemeProvider>(context);

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [

          Container(

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),

            child: SwitchListTile(

              value: themeProvider.isDark,

              onChanged: (value) {

                themeProvider.toggleTheme();
              },

              title: const Text("Dark Mode"),

              secondary: const Icon(Icons.dark_mode),
            ),
          ),

          const SizedBox(height: 20),

          buildTile(
            context,
            Icons.restore,
            "Reset Data",
            () => _showResetDialog(context),
          ),

          buildTile(
            context,
            Icons.info,
            "About App",
            () {
              showAboutDialog(
                context: context,
                applicationName: "Student Planner",
                applicationVersion: "1.0.0",
                applicationIcon: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "A comprehensive tool for students to organize subjects, study schedules, tasks, and track their progress locally on device.",
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
    );
  }

  void _showResetDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Data"),
        content: const Text(
            "Are you sure you want to delete all data? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await HiveService.clearAllData();
              if (context.mounted) {
                Provider.of<StudyProvider>(context, listen: false).refresh();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All data has been cleared")),
                );
              }
            },
            child: const Text(
              "Reset",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTile(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(

        onTap: onTap,

        leading: Icon(icon, color: Theme.of(context).primaryColor),

        title: Text(title),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      ),
    );
  }
}
