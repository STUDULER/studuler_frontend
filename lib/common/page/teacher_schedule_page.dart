import 'package:flutter/material.dart';
import 'package:studuler/common/widget/calendar_widget.dart';
import '../../main.dart';
import '../widget/background.dart';
import '../widget/schedule_item.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/model/class_day.dart';
import '../../common/model/class_feedback.dart';
import '../../common/section/calendar_date_section.dart';

class TeacherSchedulePage extends StatelessWidget {
  const TeacherSchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final httpService = HttpService();

    final PageController pageController = PageController(
      initialPage: 2400,
    );
    Jiffy date = Jiffy.now();
    final currPageIndex = ValueNotifier<int>(2400);
    final weekMode = ValueNotifier<bool>(false);
    final selectedDate = ValueNotifier<Jiffy>(Jiffy.now());

    List<ClassDay> classDays = [];
    void fetchClassDays(Jiffy date) async {
      final fetchedClassDays = await httpService.fetchClassScheduleOFMonth(
        classId: 0,
        date: date,
      );
      if (classDays.isNotEmpty) {
        classDays = fetchedClassDays;
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
                    const SizedBox(width: 12), // 앞부분에 공간 추가
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
                          },
                          child: const Icon(Icons.keyboard_arrow_right_outlined),
                        )
                            : nextMonthButton();
                      },
                    ),
                  ],
                ),
                const Gap(8), // 아래쪽 공간 줄임
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
                    // 영어 요일을 한국어로 매핑
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
                      '${value.format(pattern: 'yyyy년 MM월 dd일')} $dayKorean', // 변환된 요일 사용
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),
                ScheduleItem(
                  title: '대치동 수학 과외',
                  label: '피드백 완료',
                  isFeedbackComplete: true,
                  dotColor: const Color(0xFFB5C18E),
                ),
                ScheduleItem(
                  title: '신길동 영어 과외',
                  label: '피드백 미완료',
                  isFeedbackComplete: false,
                  dotColor: const Color(0xFFFCCFCF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
