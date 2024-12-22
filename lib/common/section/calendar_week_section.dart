import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../model/class_day.dart';
import '../widget/day_cell.dart';

class CalendarWeekSection extends StatelessWidget {
  const CalendarWeekSection({
    super.key,
    required this.classId,
    required this.selectedDate,
    required this.month,
    required this.startDayOfWeek,
    required this.classDays,
    this.opacity = 1.0,
    this.onTap,
    this.allowLongPress = false,
    this.afterAddOrDeleteClassDay, 
  });

  final int classId;
  final int month;
  final Jiffy selectedDate;
  final Jiffy startDayOfWeek;
  final List<ClassDay> classDays;
  final double opacity;

  final Function? onTap;
  final bool allowLongPress;
  final Function(Jiffy)? afterAddOrDeleteClassDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        7,
        (index) {
          final date = startDayOfWeek.add(days: index);
          final idx = classDays.indexWhere(
            (element) => element.day.isSame(date, unit: Unit.day),
          );

          return DayCell(
            classId: classId,
            onTap: onTap,
            date: date,
            selectedDate: selectedDate,
            activated: date.month == month,
            opacity: opacity,
            classDay: (idx != -1) ? classDays.elementAt(idx) : null,
            allowLongPress: allowLongPress,
            afterAddOrDeleteClassDay: afterAddOrDeleteClassDay, 
          );
        },
      ),
    );
  }
}
