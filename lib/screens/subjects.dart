import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_provider.dart';
import '../models/subject.dart';

final List<Map<String, dynamic>> subjectStyles = [

  {
    "icon": Icons.calculate,
    "color": Colors.orange,
  },

  {
    "icon": Icons.science,
    "color": Colors.blue,
  },

  {
    "icon": Icons.code,
    "color": Colors.green,
  },

  {
    "icon": Icons.menu_book,
    "color": Colors.deepPurple,
  },

  {
    "icon": Icons.language,
    "color": Colors.red,
  },

  {
    "icon": Icons.computer,
    "color": Colors.teal,
  },

  {
    "icon": Icons.biotech,
    "color": Colors.pink,
  },

  {
    "icon": Icons.auto_graph,
    "color": Colors.amber,
  },

  {
    "icon": Icons.draw,
    "color": Colors.indigo,
  },

  {
    "icon": Icons.account_balance,
    "color": Colors.cyan,
  },

  {
    "icon": Icons.public,
    "color": Colors.lime,
  },

  {
    "icon": Icons.memory,
    "color": Colors.brown,
  },

  {
    "icon": Icons.psychology,
    "color": Colors.deepOrange,
  },

  {
    "icon": Icons.music_note,
    "color": Colors.purple,
  },

  {
    "icon": Icons.sports_soccer,
    "color": Colors.lightGreen,
  },

  {
    "icon": Icons.camera_alt,
    "color": Colors.blueGrey,
  },

  {
    "icon": Icons.palette,
    "color": Colors.pinkAccent,
  },

  {
    "icon": Icons.health_and_safety,
    "color": Colors.redAccent,
  },

  {
    "icon": Icons.architecture,
    "color": Colors.orangeAccent,
  },

  {
    "icon": Icons.flight,
    "color": Colors.lightBlue,
  },

  {
    "icon": Icons.devices,
    "color": Colors.greenAccent,
  },

  {
    "icon": Icons.bar_chart,
    "color": Colors.yellow,
  },

  {
    "icon": Icons.bookmark,
    "color": Colors.deepPurpleAccent,
  },

  {
    "icon": Icons.design_services,
    "color": Colors.tealAccent,
  },

  {
    "icon": Icons.storage,
    "color": Colors.grey,
  },
];

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController hoursController =
  TextEditingController();

  void addSubject(StudyProvider studyProvider) {

    nameController.clear();
    hoursController.clear();

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          title: const Text(
            "Add Subject",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(

                controller: nameController,

                decoration: InputDecoration(

                  hintText: "Subject Name",

                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller: hoursController,

                keyboardType: TextInputType.number,

                decoration: InputDecoration(

                  hintText: "Target Hours",

                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),

              onPressed: () {

                if (nameController.text.isEmpty ||
                    hoursController.text.isEmpty) {
                  return;
                }

                final styleIndex = studyProvider.subjects.length % subjectStyles.length;
                final color = subjectStyles[styleIndex]["color"] as Color;

                final newSubject = Subject(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: nameController.text,
                  color: color.value.toRadixString(16),
                  targetHours: int.parse(hoursController.text),
                );

                studyProvider.addSubject(newSubject);

                Navigator.pop(context);
              },

              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void editSubject(StudyProvider studyProvider, int index, Subject subject) {

    nameController.text = subject.name;
    hoursController.text = subject.targetHours.toString();

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          title: const Text(
            "Edit Subject",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(

                controller: nameController,

                decoration: InputDecoration(

                  hintText: "Subject Name",

                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller: hoursController,

                keyboardType: TextInputType.number,

                decoration: InputDecoration(

                  hintText: "Target Hours",

                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(

              onPressed: () {
                subject.name = nameController.text;
                subject.targetHours = int.parse(hoursController.text);
                
                studyProvider.updateSubject(index, subject);

                Navigator.pop(context);
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void deleteSubject(StudyProvider studyProvider, int index) {
    studyProvider.deleteSubject(index);
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = Provider.of<StudyProvider>(context);
    final subjects = studyProvider.subjects;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Subjects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () => addSubject(studyProvider),

        icon: const Icon(Icons.add),

        label: const Text("Add Subject"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Your Subjects",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Manage your study targets easily",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(

              child: subjects.isEmpty

                  ? const Center(

                child: Text(
                  "No Subjects Added",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )

                  : ListView.builder(

                itemCount: subjects.length,

                itemBuilder:
                    (context, index) {

                  final subject =
                  subjects[index];

                  final Color subjectColor = Color(int.parse(subject.color, radix: 16));
                  final IconData subjectIcon = subjectStyles[index % subjectStyles.length]["icon"];

                  return GestureDetector(
                    onTap: () => editSubject(studyProvider, index, subject),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [

                        Container(

                          width: 70,
                          height: 70,

                          decoration:
                          BoxDecoration(

                            color:
                            subjectColor
                                .withOpacity(
                                0.15),

                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                          ),

                          child: Icon(

                            subjectIcon,

                            size: 38,

                            color:
                            subjectColor,
                          ),
                        ),

                        const SizedBox(
                            width: 18),

                        Expanded(

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Text(

                                subject.name,

                                style:
                                const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Text(

                                "${subject.targetHours} hrs/week",

                                style:
                                const TextStyle(
                                  color:
                                  Colors.grey,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(
                                  height: 15),

                              ClipRRect(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    20),

                                child:
                                LinearProgressIndicator(

                                  value: 0.0, // TODO: Calculate actual progress

                                  minHeight: 10,

                                  backgroundColor:
                                  Colors.grey
                                      .shade300,

                                  color:
                                  subjectColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton(

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                15),
                          ),

                          itemBuilder:
                              (context) => [

                            PopupMenuItem(

                              onTap: () {

                                Future.delayed(
                                  Duration.zero,

                                      () {

                                    editSubject(
                                        studyProvider, index, subject);
                                  },
                                );
                              },

                              child:
                              const Row(

                                children: [

                                  Icon(
                                      Icons
                                          .edit),

                                  SizedBox(
                                      width:
                                      10),

                                  Text("Edit"),
                                ],
                              ),
                            ),

                            PopupMenuItem(

                              onTap: () {

                                Future.delayed(
                                  Duration.zero,

                                      () {

                                    deleteSubject(
                                        studyProvider, index);
                                  },
                                );
                              },

                              child:
                              const Row(

                                children: [

                                  Icon(
                                    Icons
                                        .delete,
                                    color:
                                    Colors.red,
                                  ),

                                  SizedBox(
                                      width:
                                      10),

                                  Text(
                                    "Delete",

                                    style:
                                    TextStyle(
                                      color: Colors
                                          .red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          ],
        ),
      ),
    );
  }
}