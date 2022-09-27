import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  late var _calendarDataSource;

  @override
  void initState() {
    _dataCollection = getAppointments();
    _calendarDataSource = MeetingDataSource(<Appointment>[]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCalendar(
          view: CalendarView.week,
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
          dataSource: _calendarDataSource,
          loadMoreWidgetBuilder:
              (BuildContext context, LoadMoreCallback loadMoreAppointments) {
            return FutureBuilder(
              future: loadMoreAppointments(),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, List<Appointment>> getAppointments() {
    final List<String> subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Scrum');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

    final List<Color> colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));

    final Random random = Random();
    var dataCollection = <DateTime, List<Appointment>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(Duration(days: 1 + random.nextInt(2)))) {
      final DateTime date = i;
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        final int duration = random.nextInt(3);
        final Appointment meeting = Appointment(
            subject: subjectCollection[random.nextInt(7)],
            startTime: startDate,
            endTime:
                startDate.add(Duration(hours: duration == 0 ? 1 : duration)),
            color: colorCollection[random.nextInt(9)],
            isAllDay: false);

        if (dataCollection.containsKey(date)) {
          final List<Appointment> meetings = dataCollection[date]!;
          meetings.add(meeting);
          dataCollection[date] = meetings;
        } else {
          dataCollection[date] = [meeting];
        }
      }
    }
    return dataCollection;
  }
}

late Map<DateTime, List<Appointment>> _dataCollection;

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Appointment> meetings = <Appointment>[];
    DateTime appStartDate = startDate;
    DateTime appEndDate = endDate;

    while (appStartDate.isBefore(appEndDate)) {
      final List<Appointment>? data = _dataCollection[appStartDate];
      if (data == null) {
        appStartDate = appStartDate.add(const Duration(days: 1));
        continue;
      }
      for (final Appointment meeting in data) {
        if (appointments!.contains(meeting)) {
          continue;
        }
        meetings.add(meeting);
      }
      appStartDate = appStartDate.add(const Duration(days: 1));
    }
    appointments!.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}
