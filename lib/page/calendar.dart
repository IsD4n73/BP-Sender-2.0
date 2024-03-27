import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/time.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime now = DateTime(2024, 5);
  List<DateTime> listOfDay = [];
  List<int> doneDay = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  bool showCalendar = true;
  late DateTime selectedDate;

  Map<int, String> daysWeek = {
    1: "Lun",
    2: "Mar",
    3: "Mer",
    4: "Gio",
    5: "Ven",
    6: "Sab",
    7: "Dom",
  };

  @override
  void initState() {
    int totalDays = daysInMonth(now.year, now.month);
    listOfDay = List.generate(
      totalDays,
      (index) => DateTime(
        now.year,
        now.month,
        (index + 1),
      ),
    );

    selectedDate = now;

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  color: Colors.white,
                  style:
                      IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      showCalendar = !showCalendar;
                    });
                  },
                  icon: Icon(showCalendar
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat("dd MMMM yyyy", "it_IT")
                          .format(selectedDate)
                          .toTitleCase(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          showCalendar
              ? TableCalendar(
                  locale: "it_IT",
                  firstDay: listOfDay.first,
                  lastDay: listOfDay.last,
                  focusedDay: now,
                  availableGestures: AvailableGestures.none,
                  headerVisible: false,
                  daysOfWeekHeight: 50,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) =>
                        daysWeek[date.weekday] ?? "N/D",
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0x4fd0d0d0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          //padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: doneDay.contains(day.day)
                                ? Colors.green
                                : const Color(0xb6d0d0d0),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          //padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xb6d0d0d0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          //padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
