import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/section/calendar_month_section.dart';
import '../../common/section/calendar_week_section.dart';
import '../../common/util/weeks_of_month_calendar.dart';

class CalendarMonthWithSomeWeeksOfNextMonth extends StatelessWidget {
  const CalendarMonthWithSomeWeeksOfNextMonth({
    super.key,
    required this.date,
  });

  final Jiffy date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: weeksOfMonthOnCalendar(date),
          child: CalendarMonthSection(date: date),
        ),
        someWeeksOfNextMonth(),
      ],
    );
  }

  Widget someWeeksOfNextMonth() {
    const numOfWeeksToDisplay = 8;
    final numOfSomeWeeks = numOfWeeksToDisplay - weeksOfMonthOnCalendar(date);
    final Jiffy nextDate = date.add(months: 1);
    return Expanded(
      flex: numOfSomeWeeks,
      child: Column(
        children: List.generate(
          numOfSomeWeeks,
          (index) => CalendarWeekSection(
            month: nextDate.month,
            startDayOfWeek: nextDate
                .startOf(Unit.month)
                .startOf(Unit.week)
                .add(weeks: index),
            opacity: 0.33,
          ),
        ),
      ),
    );
  }
}
