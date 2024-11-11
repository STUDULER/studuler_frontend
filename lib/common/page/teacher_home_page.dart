import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../widget/class_info_card.dart';
import '../section/class_info_item.dart';
import '../widget/background.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late List<Map<String, dynamic>> classData;
  int currentIndex = 0; // 현재 카드의 인덱스를 추적

  @override
  void initState() {
    super.initState();
    classData = [
      {
        'title': '대치동 수학 과외',
        'code': 'REK45J2F',
        'completionRate': 0.75,
        'themeColor': Color(0xFFB5C18E), // 초기 테마 색상 추가
        'infoItems': [
          ClassInfoItem(icon: Icons.person, title: '학생 이름', value: '홍길동'),
          ClassInfoItem(icon: Icons.access_time, title: '회당 시간', value: '3시간'),
          ClassInfoItem(icon: Icons.calendar_today, title: '요일', value: '월/수/금'),
          ClassInfoItem(icon: Icons.payment, title: '정산 방법', value: '선불'),
          ClassInfoItem(icon: Icons.attach_money, title: '시급', value: '12500원'),
          ClassInfoItem(icon: Icons.repeat, title: '수업 횟수', value: '8회'),
          ClassInfoItem(icon: Icons.calendar_today, title: '다음 정산일', value: '9월 18일'),
        ],
      },
      {
        'title': '서초동 영어 과외',
        'code': 'ENG12345',
        'completionRate': 0.5,
        'themeColor': Color(0xFFFCCFCF), // 초기 테마 색상 추가
        'infoItems': [
          ClassInfoItem(icon: Icons.person, title: '학생 이름', value: '이몽룡'),
          ClassInfoItem(icon: Icons.access_time, title: '회당 시간', value: '2시간'),
          ClassInfoItem(icon: Icons.calendar_today, title: '요일', value: '화/목'),
          ClassInfoItem(icon: Icons.payment, title: '정산 방법', value: '후불'),
          ClassInfoItem(icon: Icons.attach_money, title: '시급', value: '15000원'),
          ClassInfoItem(icon: Icons.repeat, title: '수업 횟수', value: '5회'),
          ClassInfoItem(icon: Icons.calendar_today, title: '다음 정산일', value: '10월 10일'),
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            children: [
              const SizedBox(height: 140),
              // 커스텀 인디케이터 추가 (카드 위쪽)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(classData.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentIndex == index ? 20.0 : 8.0, // 현재 카드의 인덱스일 때는 길게 표시
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: currentIndex == index ? Colors.grey[600] : Colors.grey[400],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Swiper(
                  itemCount: classData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClassInfoCard(
                      title: classData[index]['title'],
                      code: classData[index]['code'],
                      currentIndex: index,
                      totalCards: classData.length,
                      completionRate: classData[index]['completionRate'],
                      themeColor: classData[index]['themeColor'], // 테마 색상 전달
                      infoItems: classData[index]['infoItems'],
                      onUpdate: (updatedTitle, updatedInfoItems, updatedThemeColor) {
                        setState(() {
                          classData[index]['title'] = updatedTitle;
                          classData[index]['infoItems'] = updatedInfoItems;
                          classData[index]['themeColor'] = updatedThemeColor; // 테마 색상 업데이트
                        });
                      },
                    );
                  },
                  onIndexChanged: (index) {
                    setState(() {
                      currentIndex = index; // 현재 인덱스 업데이트
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
