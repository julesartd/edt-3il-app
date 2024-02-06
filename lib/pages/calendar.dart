import 'package:flutter/material.dart';
import 'package:edt3il/api/service.dart';

class Calendar extends StatefulWidget {
  final String className;

  Calendar(this.className);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<String, dynamic> schedule = {};

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
        schedule = scheduleData as Map<String, dynamic>;
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
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Center(
        child: schedule.isEmpty
            ? CircularProgressIndicator()
            : buildScheduleTable(),
      ),
    );
  }

  Widget buildScheduleTable() {
    final List<Map<String, dynamic>> semaine =
        schedule['GROUPE']['PLAGES']['SEMAINE'];

    return ListView(
      children: semaine.map((jour) {
        final String jourText = jour['JOUR'][0]['Jour'].toString();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jour: $jourText',
                style: TextStyle(fontWeight: FontWeight.bold)),
            // Ajoutez d'autres éléments pour afficher les créneaux pour ce jour
            // Utilisez un ListView vertical ou un Column en fonction de vos besoins
          ],
        );
      }).toList(),
    );
  }
}

