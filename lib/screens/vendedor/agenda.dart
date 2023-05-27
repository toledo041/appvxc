import 'package:cell_calendar/cell_calendar.dart';
import 'package:fashion_ecommerce_app/screens/vendedor/sample_event.dart';
import 'package:flutter/material.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        events: events,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sab"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime!.year.toString();
          final month = meses[datetime.month - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  "$month  $year",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    cellCalendarPageController.animateToDate(
                      DateTime.now(),
                      curve: Curves.linear,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                )
              ],
            ),
          );
        },
        onCellTapped: (date) {
          final eventsOnTheDate = events.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("${meses[date.month - 1]} ${date.day}"),
                    actions: [
                      IconButton(
                          onPressed: (() {
                            //Navigator.pop(context);
                          }),
                          icon: const Icon(Icons.close))
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsOnTheDate
                          .map(
                            (event) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 12),
                              color: event.eventBackgroundColor,
                              child: Text(
                                event.eventName,
                                style: event.eventTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
    );
  }
}
