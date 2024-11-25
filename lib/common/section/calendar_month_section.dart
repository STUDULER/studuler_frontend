import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../util/weeks_of_month_calendar.dart';
import 'calendar_week_section.dart';

class CalendarMonthSection extends StatelessWidget {
  const CalendarMonthSection({
    super.key,
    required this.date,
  });

  final Jiffy date;

  @override
  Widget build(BuildContext context) {
    List<CalendarWeekSection> weekSections = [];
    for (var i = 0; i < weeksOfMonthOnCalendar(date); i++) {
      weekSections.add(
        CalendarWeekSection(
          month: date.month,
          startDayOfWeek:
              date.startOf(Unit.month).startOf(Unit.week).add(weeks: i),
        ),
      );
    }

    return Column(
      children: weekSections,
    );
  }
}
