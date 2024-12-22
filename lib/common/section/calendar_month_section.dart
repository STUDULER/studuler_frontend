import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../../teacher/section/feedback_scrollable_sheet_section.dart';
import '../http/http_service.dart';
import '../model/class_day.dart';
import '../model/class_feedback.dart';
import '../util/weeks_of_month_calendar.dart';
import 'calendar_week_section.dart';

class CalendarMonthSection extends StatefulWidget {
  const CalendarMonthSection({
    super.key,
    required this.classId,
    required this.date,
    this.someWeeksOfNextMonth = false,
    required this.weekMode,
    required this.selectedDate,
    required this.classFeedback, 
    required this.classDays, 
    required this.fetchClassDaysFunction,
  });

  final int classId;
  final Jiffy date;
  final bool? someWeeksOfNextMonth;
  final ValueNotifier<bool> weekMode;
  final ValueNotifier<Jiffy> selectedDate;
  final ValueNotifier<ClassFeedback?> classFeedback;
  final List<ClassDay> classDays;
  final Function(Jiffy) fetchClassDaysFunction;

  @override
  State<CalendarMonthSection> createState() => _CalendarMonthSectionState();
}

class _CalendarMonthSectionState extends State<CalendarMonthSection> {
  final httpService = HttpService();

  final sidePadding = const EdgeInsets.symmetric(horizontal: 12);

  int? selectedIndex;

  final DraggableScrollableController bottomSheetController =
      DraggableScrollableController();
  double? lastBottomSheetSize;

  Jiffy lastFetchTime = Jiffy.now();

  @override
  void initState() {
    super.initState();
    bottomSheetController.addListener(() {
      lastBottomSheetSize ??= bottomSheetController.size;
      if (lastBottomSheetSize! > bottomSheetController.size &&
          bottomSheetController.size < 0.00001) {
        setState(() {
          selectedIndex = null;
        });
        widget.weekMode.value = false;
        widget.selectedDate.value = widget.date;
        lastBottomSheetSize = null;
      }
    });
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CalendarWeekSection> weekSections = [];
    for (var i = 0; i < weeksOfMonthOnCalendar(widget.date); i++) {
      weekSections.add(
        CalendarWeekSection(
          onTap: (int index, Jiffy date) {
            if (widget.weekMode.value == true) {
              widget.selectedDate.value = date;
            } else {
              bottomSheetController.animateTo(
                7 / 8,
                duration: Durations.long2,
                curve: Curves.easeInOut,
              );
              widget.weekMode.value = true;
              widget.selectedDate.value = date;
              setState(() {
                selectedIndex = selectedIndex == index ? null : index;
              });
            }
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
        final maxBottomSheetFractionalValue =
            (weekSections.length - 1) / weekSections.length;

        return Stack(
          children: List<Widget>.generate(weekSections.length, (index) {
                // Calculate initial positions dynamically
                final topPosition = componentHeight * index;

                // Decide the final position based on the selected index
                double targetTopPosition;
                if (selectedIndex == null) {
                  targetTopPosition =
                      topPosition; // No selection, keep in place
                } else if (selectedIndex == index) {
                  targetTopPosition = 0; // Selected component moves to the top
                } else if (index < selectedIndex!) {
                  targetTopPosition = -componentHeight; // Move upwards
                } else {
                  targetTopPosition = parentHeight; // Move downwards
                }

                return AnimatedPositioned(
                  key: ValueKey(index),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  top: targetTopPosition,
                  left: 0,
                  right: 0,
                  height: componentHeight,
                  child: ValueListenableBuilder(
                    valueListenable: widget.selectedDate,
                    builder: (context, selectedDate, child) {
                      if (widget.weekMode.value == false) {
                        return weekSections.elementAt(index);
                      }
                      return CalendarWeekSection(
                        onTap: (int index, Jiffy date) {
                          if (widget.weekMode.value == true) {
                            widget.selectedDate.value = date;
                          }
                        },
                        classId: widget.classId,
                        month: selectedDate.month,
                        selectedDate: selectedDate,
                        startDayOfWeek: selectedDate.startOf(Unit.week),
                        classDays: widget.classDays, 
                      );
                    },
                  ),
                );
              }).toList() +
              [
                FeedbackScrollableSheetSection(
                  bottomSheetController: bottomSheetController,
                  maxBottomSheetFractionalValue: maxBottomSheetFractionalValue,
                  selectedDate: widget.selectedDate,
                  classFeedback: widget.classFeedback,
                  classDay: widget.classDays,
                ),
              ],
        );
      },
    );
  }
}
