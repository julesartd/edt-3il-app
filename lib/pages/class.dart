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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0,80,103,1),
        title: const Text('Salut ! ', style:
            TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromRGBO(0,80,103,1),
                    ),
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                classes[index]['name'],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Voir l\'emploi du temps',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Calendar(classes[index]['name']),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
