import 'package:edt3il/api/service.dart';
import 'package:flutter/material.dart';

import 'calendar.dart';

class Class extends StatefulWidget {
  const Class({super.key});

  @override
  ClassState createState() => ClassState();
}

class ClassState extends State<Class> {
  List<Map<String, dynamic>> classes = [];
  String? selectedClass;
  bool showClassesList = false;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    showClassesList = false;

    if (!dataLoaded) {
      loadData();
    }
  }

  Future<void> loadData() async {
    try {
      final List<Map<String, dynamic>> classesData =
          await ApiService.getClasses();
      setState(() {
        classes = classesData;
        dataLoaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text(
                'Sélectionnez une classe',
                style: TextStyle(fontSize: 25),
              ),
              value: selectedClass,
              onChanged: (String? value) {
                setState(() {
                  selectedClass = value;
                  showClassesList = true;
                });

                if (selectedClass != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Calendar(selectedClass!)),
                  );
                }
              },
              items: classes.map((classData) {
                return DropdownMenuItem<String>(
                  value: classData['name'],
                  child: Text(classData['name']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
