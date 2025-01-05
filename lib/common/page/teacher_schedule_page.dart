import 'package:flutter/material.dart';
import 'package:studuler/common/widget/calendar_widget.dart';
import '../../main.dart';
import '../widget/background.dart';
import '../widget/schedule_item.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/model/class_day.dart';
import '../../common/section/calendar_date_section.dart';

class TeacherSchedulePage extends StatefulWidget {
  const TeacherSchedulePage({Key? key}) : super(key: key);

  @override
  State<TeacherSchedulePage> createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
  final HttpService httpService = HttpService();

  final PageController pageController = PageController(initialPage: 2400);
  final ValueNotifier<int> currPageIndex = ValueNotifier<int>(2400);
  final ValueNotifier<bool> weekMode = ValueNotifier<bool>(false);
  final ValueNotifier<Jiffy> selectedDate = ValueNotifier<Jiffy>(Jiffy.now());

  Jiffy date = Jiffy.now();
  List<ClassDay> classDays = [];
  List<Map<String, dynamic>> scheduleItems = []; // 선택된 날짜의 일정 데이터

  // 월별 일정 가져오기
  void fetchClassDays(Jiffy date) async {
    final fetchedClassDays = await httpService.fetchClassScheduleOFMonth(
      classId: 0,
      date: date,
    );
    setState(() {
      classDays = fetchedClassDays;
    });
  }

  // 날짜별 일정 가져오기
  Future<void> fetchScheduleForSelectedDate(String date) async {
    try {
      final response = await httpService.fetchClassesByDate(date);
      setState(() {
        scheduleItems = response;
      });
    } catch (e) {
      print("Error fetching schedule: $e");
    }
  }

  GestureDetector prevMonthButton() {
    return GestureDetector(
      onTap: () {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.keyboard_arrow_left_outlined),
    );
  }

  GestureDetector nextMonthButton() {
    return GestureDetector(
      onTap: () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: const Icon(Icons.keyboard_arrow_right_outlined),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchClassDays(date);
    fetchScheduleForSelectedDate(selectedDate.value.format(pattern: 'yyyy-MM-dd'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            iconActionButtons: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => mainScaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '전체 일정',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Gap(20),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    ValueListenableBuilder<Jiffy>(
                      valueListenable: selectedDate,
                      builder: (context, value, child) {
                        return Text(
                          "${value.year}년 ${value.month}월",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: weekMode,
                      builder: (context, weekMode, child) {
                        return weekMode
                            ? GestureDetector(
                          onTap: () {
                            selectedDate.value =
                                selectedDate.value.subtract(weeks: 1);
                            fetchScheduleForSelectedDate(
                              selectedDate.value.format(pattern: 'yyyy-MM-dd'),
                            );
                          },
                          child: const Icon(
                              Icons.keyboard_arrow_left_outlined),
                        )
                            : prevMonthButton();
                      },
                    ),
                    const SizedBox(width: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: weekMode,
                      builder: (context, weekMode, child) {
                        return weekMode
                            ? GestureDetector(
                          onTap: () {
                            selectedDate.value =
                                selectedDate.value.add(weeks: 1);
                            fetchScheduleForSelectedDate(
                              selectedDate.value.format(pattern: 'yyyy-MM-dd'),
                            );
                          },
                          child: const Icon(
                              Icons.keyboard_arrow_right_outlined),
                        )
                            : nextMonthButton();
                      },
                    ),
                  ],
                ),
                const Gap(8),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      color: Colors.white,
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
                                return CalendarWidget(
                                  classId: 0,
                                  date: date.add(months: index - 2400),
                                  someWeeksOfNextMonth: false,
                                  weekMode: weekMode,
                                  selectedDate: selectedDate,
                                  classDays: classDays,
                                  fetchClassDaysFunction: fetchClassDays,
                                  onDateSelected: (clickedDate) {
                                    fetchScheduleForSelectedDate(clickedDate);
                                  },
                                );
                              },
                              onPageChanged: (value) async {
                                if (currPageIndex.value > value) {
                                  selectedDate.value =
                                      selectedDate.value.subtract(months: 1);
                                } else {
                                  selectedDate.value =
                                      selectedDate.value.add(months: 1);
                                }
                                currPageIndex.value = value;
                                fetchClassDays(selectedDate.value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                const Divider(),
                const SizedBox(height: 10),
                ValueListenableBuilder<Jiffy>(
                  valueListenable: selectedDate,
                  builder: (context, value, child) {
                    final dayInKorean = {
                      'Monday': '월요일',
                      'Tuesday': '화요일',
                      'Wednesday': '수요일',
                      'Thursday': '목요일',
                      'Friday': '금요일',
                      'Saturday': '토요일',
                      'Sunday': '일요일',
                    };

                    final dayInEnglish = value.format(pattern: 'EEEE');
                    final dayKorean = dayInKorean[dayInEnglish] ?? dayInEnglish;

                    return Text(
                      '${value.format(pattern: 'yyyy년 MM월 dd일')} $dayKorean',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // 기본 예시 "대치동 수학 과외"를 항상 표시
                const ScheduleItem(
                  title: "대치동 수학 과외",
                  label: "피드백 완료",
                  isFeedbackComplete: true,
                  dotColor: Color(0xFFB5C18E),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: scheduleItems.length,
                    itemBuilder: (context, index) {
                      final schedule = scheduleItems[index];
                      return ScheduleItem(
                        title: schedule['classname'],
                        label: schedule['feedbackStatus'],
                        isFeedbackComplete:
                        schedule['feedbackStatus'] == '피드백 완료',
                        dotColor: Color(schedule['themecolor']),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
