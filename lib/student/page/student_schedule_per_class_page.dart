import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/model/class_day.dart';
import '../../common/model/class_feedback.dart';
import '../../common/section/calendar_date_section.dart';
import '../../common/section/calendar_month_section.dart';
import '../../common/widget/background.dart';
import '../../main.dart';

class StudentSchedulePerClassPage extends StatefulWidget {
  const StudentSchedulePerClassPage({
    super.key,
    required this.className,
    required this.classId,
    required this.classColor,
  });

  final String className;
  final int classId;
  final int classColor;

  @override
  State<StudentSchedulePerClassPage> createState() =>
      _StudentSchedulePerClassPageState();
}

class _StudentSchedulePerClassPageState
    extends State<StudentSchedulePerClassPage> {
  final httpService = HttpService();

  final sidePadding = const EdgeInsets.symmetric(horizontal: 12);

  final PageController pageController = PageController(
    initialPage: 2400,
  );
  Jiffy date = Jiffy.now();
  final currPageIndex = ValueNotifier<int>(2400);

  final weekMode = ValueNotifier<bool>(false);
  final selectedDate = ValueNotifier<Jiffy>(Jiffy.now());
  final classFeedback = ValueNotifier<ClassFeedback?>(null);

  @override
  void initState() {
    fetchClassDays(selectedDate.value);
    super.initState();
    selectedDate.addListener(() async {
      classFeedback.value = await httpService.fetchClassFeedback(
        classId: widget.classId,
        date: selectedDate.value,
      );
      fetchClassDays(selectedDate.value);
    });
  }

  List<ClassDay> classDays = [];
  void fetchClassDays(Jiffy date) async {
    final fetchedClassDays = await httpService.fetchClassSchedulePerPageOFMonth(
      classId: widget.classId,
      date: date,
    );
    if (mounted) {
      setState(() {
        classDays = fetchedClassDays;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            isTeacher: false,
            colorIndex: widget.classColor,
            iconActionButtons: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => mainScaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
          ), // 배경 추가
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: sidePadding,
                        child: Row(
                          children: [
                            ValueListenableBuilder<Jiffy>(
                              valueListenable: selectedDate,
                              builder: (
                                BuildContext context,
                                Jiffy value,
                                Widget? child,
                              ) {
                                return Text(
                                  "${value.year}년 ${value.month}월",
                                );
                              },
                              // child: Text(displayDate.MMMMEEEEd)
                            ),
                            const Spacer(),
                            ValueListenableBuilder<bool>(
                              valueListenable: weekMode,
                              builder: (context, weekMode, child) {
                                if (weekMode) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedDate.value =
                                          selectedDate.value.add(weeks: -1);
                                    },
                                    child: const Icon(
                                      Icons.keyboard_arrow_left_outlined,
                                    ),
                                  );
                                } else {
                                  return prevMonthButton();
                                }
                              },
                            ),
                            const Gap(12),
                            ValueListenableBuilder<bool>(
                              valueListenable: weekMode,
                              builder: (context, weekMode, child) {
                                if (weekMode) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedDate.value =
                                          selectedDate.value.add(weeks: 1);
                                    },
                                    child: const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                    ),
                                  );
                                } else {
                                  return nextMonthButton();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              const Gap(16),
                              const CalendarDateSection(),
                              Expanded(
                                child: PageView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: weekMode.value
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(),
                                  controller: pageController,
                                  itemBuilder: (context, index) {
                                    return CalendarMonthSection(
                                      isTeacher: false,
                                      classId: widget.classId,
                                      date: date.add(months: index - 2400),
                                      someWeeksOfNextMonth: true,
                                      weekMode: weekMode,
                                      selectedDate: selectedDate,
                                      classFeedback: classFeedback,
                                      classDays: classDays,
                                      fetchClassDaysFunction: fetchClassDays,
                                    );
                                  },
                                  onPageChanged: (value) async {
                                    if (currPageIndex.value > value) {
                                      selectedDate.value =
                                          selectedDate.value.add(months: -1);
                                    } else {
                                      selectedDate.value =
                                          selectedDate.value.add(months: 1);
                                    }
                                    currPageIndex.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector nextMonthButton() {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          currPageIndex.value + 1,
          duration: Durations.long1,
          curve: Curves.easeIn,
        );
      },
      child: const Icon(
        Icons.keyboard_arrow_down_outlined,
      ),
    );
  }

  GestureDetector prevMonthButton() {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          currPageIndex.value - 1,
          duration: Durations.long1,
          curve: Curves.easeIn,
        );
      },
      child: const Icon(
        Icons.keyboard_arrow_up_outlined,
      ),
    );
  }
}
