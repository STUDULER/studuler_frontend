import 'package:flutter/material.dart';
import '../../main.dart';
import '../widget/background.dart'; // background.dart import
import '../widget/calendar_widget.dart'; // 가상의 캘린더 위젯 import
import '../widget/schedule_item.dart'; // 분리된 ScheduleItem 위젯 import

class TeacherSchedulePage extends StatelessWidget {
  const TeacherSchedulePage({Key? key}) : super(key: key);

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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 100.0,
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
                  const SizedBox(height: 20),
                  CalendarWidget(classData: classData), // 가상의 캘린더 위젯 추가
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    '2024년 9월 8일 일요일',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ScheduleItem 위젯들
                  ScheduleItem(
                    title: '대치동 수학 과외',
                    label: '피드백 완료',
                    isFeedbackComplete: true,
                    dotColor: const Color(0xFFB5C18E), // 수업 코드 색상
                  ),
                  ScheduleItem(
                    title: '신길동 영어 과외',
                    label: '피드백 미완료',
                    isFeedbackComplete: false,
                    dotColor: const Color(0xFFFCCFCF), // 수업 코드 색상
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
