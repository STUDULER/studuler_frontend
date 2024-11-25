import 'package:jiffy/jiffy.dart';

int weeksOfMonthOnCalendar(Jiffy date) {
  return date
          .endOf(Unit.month)
          .endOf(Unit.week)
          .diff(
            date.startOf(Unit.month).startOf(Unit.week),
            unit: Unit.week,
          )
          .toInt() +
      1;
}
