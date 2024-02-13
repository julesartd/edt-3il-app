import 'package:flutter/material.dart';
import 'package:edt3il/api/service.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final String className;

  Calendar(this.className);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Map<String, dynamic>> schedule = [];

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    try {
      // Utilisez les données fictives en mode de développement local
      final scheduleData = await ApiService.getCalendar(widget.className);

      setState(() {
        schedule = scheduleData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emploi du temps - ${widget.className}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: Center(
        child: schedule.isEmpty
            ? const CircularProgressIndicator()
            : buildScheduleTable(),
      ),
    );
  }

  Widget buildScheduleTable() {
    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (BuildContext context, int index) {
        var daySchedule = schedule[index];
        DateTime date = DateFormat('dd/MM/yyyy').parse(daySchedule['date']);
        String formattedDate = DateFormat('dd/MM/yyyy').format(date);

        return Column(
          children: [
            Text("${_getDayOfWeek(date)} - $formattedDate",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            Padding(padding: const EdgeInsets.all(16.0)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: daySchedule['cours'].length,
              itemBuilder: (BuildContext context, int index) {
                var course = daySchedule['cours'][index];

                if (course['creneau'] == '3') {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAUSE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (course['activite'] == null || course['activite'].isEmpty) {
                  return Container();
                }

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${course['activite']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Horaire: ${course['horaire']['start']} - ${course['horaire']['end']}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Salle: ${course['salle'] ?? 'Non spécifié'}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

String _getDayOfWeek(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'Lundi';
    case DateTime.tuesday:
      return 'Mardi';
    case DateTime.wednesday:
      return 'Mercredi';
    case DateTime.thursday:
      return 'Jeudi';
    case DateTime.friday:
      return 'Vendredi';
    case DateTime.saturday:
      return 'Samedi';
    case DateTime.sunday:
      return 'Dimanche';
    default:
      return '';
  }
}
