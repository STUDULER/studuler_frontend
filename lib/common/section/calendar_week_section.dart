import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../widget/day_cell.dart';

class CalendarWeekSection extends StatelessWidget {
  const CalendarWeekSection({
    super.key,
    required this.month,
    required this.startDayOfWeek,
    this.opacity = 1.0,
  });

  final int month;
  final Jiffy startDayOfWeek;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: List.generate(
          7,
          (index) {
            final date = startDayOfWeek.add(days: index);
            return DayCell(
              date: date,
              activated: date.month == month,
              opacity: opacity,
            );
          },
        ),
      ),
    );
  }
}
