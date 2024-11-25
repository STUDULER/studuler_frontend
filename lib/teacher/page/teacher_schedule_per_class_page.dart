import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/section/calendar_date_section.dart';
import '../../common/widget/background.dart';
import '../../main.dart';
import '../section/calendar_month_with_some_weeks_of_next_month.dart';

class TeacherSchedulePerClassPage extends StatefulWidget {
  const TeacherSchedulePerClassPage({Key? key}) : super(key: key);

  @override
  State<TeacherSchedulePerClassPage> createState() =>
      _TeacherSchedulePerClassPageState();
}

class _TeacherSchedulePerClassPageState
    extends State<TeacherSchedulePerClassPage> {
  final PageController pageController = PageController(
    initialPage: 2400,
  );
  Jiffy date = Jiffy.now();
  final currPageIndex = ValueNotifier<int>(2400);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 클래스 데이터 정의
    final classData = [
      {
        'title': '대치동 수학 과외',
        'code': 'REK45J2F',
        'completionRate': 3 / 8,
        'themeColor': const Color(0xFFB5C18E), // 수업 코드에 따른 색상
        'infoItems': [
          {'icon': Icons.person, 'title': '학생 이름', 'value': '홍길동'},
          {'icon': Icons.access_time, 'title': '회당 시간', 'value': '3시간'},
          {'icon': Icons.calendar_today, 'title': '요일', 'value': '월/수/금'},
          {'icon': Icons.payment, 'title': '정산 방법', 'value': '선불'},
          {'icon': Icons.attach_money, 'title': '시급', 'value': '12500원'},
          {'icon': Icons.repeat, 'title': '수업 횟수', 'value': '8회'},
          {'icon': Icons.calendar_today, 'title': '다음 정산일', 'value': '9월 18일'},
        ],
      },
      {
        'title': '서초동 영어 과외',
        'code': 'ENG12345',
        'completionRate': 3 / 4,
        'themeColor': const Color(0xFFFCCFCF), // 수업 코드에 따른 색상
        'infoItems': [
          {'icon': Icons.person, 'title': '학생 이름', 'value': '이몽룡'},
          {'icon': Icons.access_time, 'title': '회당 시간', 'value': '2시간'},
          {'icon': Icons.calendar_today, 'title': '요일', 'value': '화/목'},
          {'icon': Icons.payment, 'title': '정산 방법', 'value': '후불'},
          {'icon': Icons.attach_money, 'title': '시급', 'value': '15000원'},
          {'icon': Icons.repeat, 'title': '수업 횟수', 'value': '4회'},
          {'icon': Icons.calendar_today, 'title': '다음 정산일', 'value': '10월 10일'},
        ],
      },
    ];

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
                const Text(
                  '전체 일정',
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            ValueListenableBuilder<int>(
                              valueListenable: currPageIndex,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                final displayDate = date.add(
                                  months: currPageIndex.value - 2400,
                                );
                                return Text(
                                  "${displayDate.year}년 ${displayDate.month}월",
                                );
                              },
                              // child: Text(displayDate.MMMMEEEEd)
                            ),
                            const Spacer(),
                            GestureDetector(
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
                            ),
                            const Gap(12),
                            GestureDetector(
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
                                  controller: pageController,
                                  itemBuilder: (context, index) {
                                    return CalendarMonthWithSomeWeeksOfNextMonth(
                                      date: date.add(months: index - 2400),
                                    );
                                  },
                                  onPageChanged: (value) {
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
}
