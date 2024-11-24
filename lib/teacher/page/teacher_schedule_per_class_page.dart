import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:studuler/common/section/calendar_date_section.dart';
import '../../common/widget/background.dart';
import '../../main.dart';

class TeacherSchedulePerClassPage extends StatelessWidget {
  const TeacherSchedulePerClassPage({Key? key}) : super(key: key);

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
          const Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전체 일정',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Dummy(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dummy extends StatelessWidget {
  const Dummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Row(
            children: [
              Text("2024년 11월"),
              Spacer(),
              Icon(Icons.keyboard_arrow_up_outlined),
              Gap(4),
              Icon(Icons.keyboard_arrow_down_outlined),
            ],
          ),
          const Gap(8),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Gap(16),
                  const CalendarDateSection(),
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                // color: Colors.red,
                                child: const Center(
                                  child: Text("1"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
