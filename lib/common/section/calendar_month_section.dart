import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../http/http_service.dart';
import '../model/class_day.dart';
import '../util/weeks_of_month_calendar.dart';
import '../widget/auth_text_field.dart';
import 'calendar_week_section.dart';

class CalendarMonthSection extends StatefulWidget {
  const CalendarMonthSection({
    super.key,
    required this.date,
    this.someWeeksOfNextMonth = false,
    required this.weekMode,
    required this.selectedDate,
  });

  final Jiffy date;
  final bool? someWeeksOfNextMonth;
  final ValueNotifier<bool> weekMode;
  final ValueNotifier<Jiffy> selectedDate;

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

  List<ClassDay> classDays = [];
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
    fetchClassDays(widget.date);
    widget.selectedDate.addListener(() {
      if (lastFetchTime.add(seconds: 1).isBefore(Jiffy.now())) {
        fetchClassDays(widget.selectedDate.value);
      }
    });
  }

  void fetchClassDays(Jiffy date) async {
    final fetchedClassDays = await httpService.fetchClassScheduleOFMonth(
      classId: 0,
      date: date,
    );
    lastFetchTime = Jiffy.now();
    if (mounted) {
      setState(() {
        classDays = fetchedClassDays;
      });
    }
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    super.dispose();
  }

  String _dateToString(Jiffy date) {
    String weekday = "";
    switch (date.dateTime.weekday) {
      case 1:
        weekday = "월요일";
        break;
      case 2:
        weekday = "화요일";
        break;
      case 3:
        weekday = "수요일";
        break;
      case 4:
        weekday = "목요일";
        break;
      case 5:
        weekday = "금요일";
        break;
      case 6:
        weekday = "토요일";
        break;
      case 7:
      default:
        weekday = "일요일";
        break;
    }
    return "${date.year}년 ${date.month}월 ${date.dateTime.day}일 $weekday";
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
          month: widget.date.month,
          startDayOfWeek:
              widget.date.startOf(Unit.month).startOf(Unit.week).add(weeks: i),
          classDays: classDays,
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
            month: nextDate.month,
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
                    builder: (context, selecttedDate, child) {
                      if (widget.weekMode.value == false) {
                        return weekSections.elementAt(index);
                      }
                      return CalendarWeekSection(
                        month: selecttedDate.month,
                        startDayOfWeek: selecttedDate.startOf(Unit.week),
                        classDays: classDays,
                      );
                    },
                  ),
                );
              }).toList() +
              [
                DraggableScrollableSheet(
                  controller: bottomSheetController,
                  initialChildSize: 0,
                  minChildSize: 0,
                  maxChildSize: maxBottomSheetFractionalValue,
                  snap: true,
                  snapSizes: [maxBottomSheetFractionalValue],
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: ValueListenableBuilder(
                        valueListenable: widget.selectedDate,
                        builder: (
                          BuildContext context,
                          Jiffy value,
                          Widget? child,
                        ) {
                          return Container(
                            color: Colors.white,
                            child: Padding(
                              padding: sidePadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const Gap(8),
                                  Text(
                                    _dateToString(value),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                  const Gap(28),
                                  AuthTextField(
                                    controller: TextEditingController(),
                                    label: "오늘 한 일",
                                    hintText: "오늘 한 일을 적어주세요.",
                                    readOnly: true,
                                  ),
                                  const Gap(16),
                                  AuthTextField(
                                    controller: TextEditingController(),
                                    label: "태도",
                                    hintText: "태도를 적어주세요.",
                                    readOnly: true,
                                  ),
                                  const Gap(16),
                                  Text(
                                    "숙제 완료 여부",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {},
                                        style: const ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.black87,
                                          ),
                                          overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent,
                                          ),
                                        ),
                                        icon: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color: const Color(0xffffec9e),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: buttonActivated == 2
                                            //     ? const Color(0xffffec9e)
                                            //     : Colors.white70,
                                            color: const Color(0xffffec9e),
                                          ),
                                        ),
                                        label: const Text("부분완료"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        style: const ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.black87,
                                          ),
                                          overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent,
                                          ),
                                        ),
                                        icon: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color: const Color(0xffffec9e),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: buttonActivated == 2
                                            //     ? const Color(0xffffec9e)
                                            //     : Colors.white70,
                                            color: const Color(0xffffec9e),
                                          ),
                                        ),
                                        label: const Text("부분완료"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {},
                                        style: const ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.black87,
                                          ),
                                          overlayColor: WidgetStatePropertyAll(
                                            Colors.transparent,
                                          ),
                                        ),
                                        icon: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color: const Color(0xffffec9e),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // color: buttonActivated == 2
                                            //     ? const Color(0xffffec9e)
                                            //     : Colors.white70,
                                            color: const Color(0xffffec9e),
                                          ),
                                        ),
                                        label: const Text("부분완료"),
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  AuthTextField(
                                    controller: TextEditingController(),
                                    label: "메모",
                                    hintText: "메모를 적어주세요.",
                                    readOnly: true,
                                  ),
                                  const Gap(16),
                                  Text(
                                    "수업 점수",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: 5,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 10,
                                    itemSize: 32,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (_) {},
                                  ),
                                  const Gap(16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
        );
      },
    );
  }
}
