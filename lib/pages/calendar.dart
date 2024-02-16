import 'package:flutter/material.dart';
import 'package:edt3il/api/service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Calendar extends StatefulWidget {
  final String className;

  Calendar(this.className);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Map<String, dynamic>> schedule = [];
  late PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    try {
      final scheduleData = await ApiService.getCalendar(widget.className);

      setState(() {
        schedule = scheduleData;
      });

      // Trouver l'index de la date actuelle dans le calendrier
      int todayIndex = schedule.indexWhere((daySchedule) {
        DateTime scheduleDate =
            DateFormat('dd/MM/yyyy').parse(daySchedule['date']);
        DateTime now = DateTime.now();
        return scheduleDate.day == now.day &&
            scheduleDate.month == now.month &&
            scheduleDate.year == now.year;
      });

      // Si la date actuelle est trouvée dans le calendrier, initialiser le PageController à cette page
      if (todayIndex != -1) {
        _pageController = PageController(initialPage: todayIndex);
        currentPage = todayIndex;
      } else {
        _pageController = PageController(initialPage: 0);
      }
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
            : buildSchedulePageView(),
      ),
    );
  }

  Widget buildSchedulePageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: schedule.length,
      onPageChanged: (int page) {
        setState(() {
          currentPage = page;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final currentDaySchedule = schedule[index];

        return buildScheduleTable(currentDaySchedule);
      },
    );
  }

  Widget buildScheduleTable(Map<String, dynamic> daySchedule) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text(
          "${getDayOfWeek(DateFormat('dd/MM/yyyy').parse(daySchedule['date']))} - ${daySchedule['date']}",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: daySchedule['cours'].length,
            itemBuilder: (BuildContext context, int index) {
              var course = daySchedule['cours'][index];

              // Si 'activite' est null et ce n'est pas le créneau 3, retournez un Container vide
              if (course['activite'] == null && index != 2) {
                return Container();
              }

              // Si c'est le créneau 3 et 'activite' est null, affichez "Pause"pp
              if (index == 2 && course['activite'] == null) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84F13),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Pause',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFE84F13)),
                ),
                child: Row(
                  children: [
                    Expanded(
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
                    ),
                    SvgPicture.asset(
                      'assets/images/3il.svg',
                      height: 20.0, // You can adjust the size as needed
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String getDayOfWeek(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Lundi';
    case 2:
      return 'Mardi';
    case 3:
      return 'Mercredi';
    case 4:
      return 'Jeudi';
    case 5:
      return 'Vendredi';
    default:
      return '';
  }
}
