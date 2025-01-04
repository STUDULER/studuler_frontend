import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../http/http_service.dart';
import '../model/class_day.dart';
import '../util/weeks_of_month_calendar.dart';
import '../../common/section/calendar_week_section.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.classId,
    required this.date,
    this.someWeeksOfNextMonth = false,
    required this.weekMode,
    required this.selectedDate,
    required this.classDays,
    required this.fetchClassDaysFunction,
  });

  final int classId;
  final Jiffy date;
  final bool? someWeeksOfNextMonth;
  final ValueNotifier<bool> weekMode;
  final ValueNotifier<Jiffy> selectedDate;
  final List<ClassDay> classDays;
  final Function(Jiffy) fetchClassDaysFunction;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final httpService = HttpService();

  final sidePadding = const EdgeInsets.symmetric(horizontal: 12);

  Jiffy lastFetchTime = Jiffy.now();

  @override
  Widget build(BuildContext context) {
    List<CalendarWeekSection> weekSections = [];
    for (var i = 0; i < weeksOfMonthOnCalendar(widget.date); i++) {
      weekSections.add(
        CalendarWeekSection(
          onTap: (int index, Jiffy date) {
            // 날짜를 클릭하면 선택된 날짜를 업데이트
            setState(() {
              widget.selectedDate.value = date;
            });
          },
          allowLongPress: true,
          afterAddOrDeleteClassDay: widget.fetchClassDaysFunction,
          classId: widget.classId,
          selectedDate: widget.selectedDate.value,
          month: widget.date.month,
          startDayOfWeek:
          widget.date.startOf(Unit.month).startOf(Unit.week).add(weeks: i),
          classDays: widget.classDays,
        ),
      );
    }
    if (widget.someWeeksOfNextMonth == true) {
      const numOfWeeksToDisplay = 8;
      final numOfSomeWeeks =
          numOfWeeksToDisplay - weeksOfMonthOnCalendar(widget.date);
      final Jiffy nextDate = widget.date.add(months: 1);
      weekSections.addAll(
        List.generate(
          numOfSomeWeeks,
              (index) => CalendarWeekSection(
            classId: widget.classId,
            month: nextDate.month,
            selectedDate: widget.selectedDate.value,
            startDayOfWeek: nextDate
                .startOf(Unit.month)
                .startOf(Unit.week)
                .add(weeks: index),
            opacity: 0.33,
            classDays: const [],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final parentHeight = constraints.maxHeight;
        final componentHeight = parentHeight / weekSections.length;

        return Stack(
          children: List<Widget>.generate(weekSections.length, (index) {
            final topPosition = componentHeight * index;

            return Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              height: componentHeight,
              child: ValueListenableBuilder(
                valueListenable: widget.selectedDate,
                builder: (context, selectedDate, child) {
                  return weekSections.elementAt(index);
                },
              ),
            );
          }),
        );
      },
    );
  }
}
