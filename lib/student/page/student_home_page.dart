import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../common/http/http_service.dart';
import '../../common/widget/background.dart';
import '../../common/widget/class_info_card.dart';
import '../../main.dart';
import '../widget/class_info_card_student.dart';
import 'add_class_page_student.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({
    super.key,
    required this.goToPerClassPage,
  });

  final Function(int, String, int) goToPerClassPage;

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
Future<List<Map<String, dynamic>>>? futureClassData;
  List<Map<String, dynamic>>? classData; // 수업 데이터를 로컬에 유지
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshClassData();
  }

  void _refreshClassData() {
    setState(() {
      futureClassData = HttpService().fetchClassesStudent().then((data) {
        setState(() {
          classData = data; // 로컬에 데이터 저장
        });
        return data;
      });
    });
  }

  void _removeClass(int classId) {
    setState(() {
      // 데이터 삭제
      classData?.removeWhere((classItem) => classItem['classId'] == classId);

      // 현재 인덱스를 삭제된 데이터 이후로 조정
      if (currentIndex >= (classData?.length ?? 0)) {
        currentIndex = (classData?.length ?? 1) - 1;
      }

      // Swiper를 강제로 재빌드
      futureClassData = Future.value(classData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Background(
            isTeacher: false,
            iconActionButtons: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClassPageStudent(),
                    ),
                  );
                  if (result != null && result == true) {
                    _refreshClassData();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => mainScaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureClassData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final errorMessage = snapshot.error.toString();
                if (errorMessage.contains('No classes available')) {
                  // 특정 에러 메시지일 경우 빈 카드 표시
                  return _buildEmptyCard(screenHeight, screenWidth);
                } else {
                  // 그 외의 에러는 에러 메시지 표시
                  return const Center(
                    child: Text(
                      '오류가 발생했습니다. 다시 시도해주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
              } else if (classData != null && classData!.isNotEmpty) {
                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(classData!.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                          width: currentIndex == index ? screenWidth * 0.06 : screenWidth * 0.02,
                          height: screenHeight * 0.01,
                          decoration: BoxDecoration(
                            color: currentIndex == index ? Colors.grey[600] : Colors.grey[400],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Expanded(
                      child: Swiper(
                        key: ValueKey(classData), // classData가 변경될 때마다 Swiper 재렌더링
                        itemCount: classData!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final classItem = classData![index];
                          return ClassInfoCardStudent(
                            title: classItem['title'],
                            code: classItem['code'],
                            classId: classItem['classId'],
                            currentIndex: index,
                            totalCards: classData!.length,
                            completionRate: classItem['completionRate'],
                            finishedLessons: classItem['finishedLessons'],
                            period: classItem['period'],
                            themeColor: classItem['themeColor'],
                            infoItems: classItem['infoItems'],
                            onUpdate: (updatedTitle, updatedInfoItems, updatedThemeColor) {
                              setState(() {
                                classData![index]['title'] = updatedTitle;
                                classData![index]['infoItems'] = updatedInfoItems;
                                classData![index]['themeColor'] = updatedThemeColor;
                              });
                            },
                            goToPerClassPage: widget.goToPerClassPage,
                          );
                        },
                        loop: false,
                        onIndexChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                );
              } else {
                // 빈 카드 표시
                return _buildEmptyCard(screenHeight, screenWidth);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(double screenHeight, double screenWidth) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddClassPageStudent(),
            ),
          );
          if (result != null && result == true) {
            _refreshClassData();
          }
        },
        child: Container(
          width: screenWidth * 0.93,
          // 화면 가로 길이의 93%
          height: screenHeight * 0.67,
          // 화면 세로 길이의 67%
          margin: EdgeInsets.only(top: screenHeight * 0.22),
          // 카드 위치 아래로 이동
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: screenHeight * 0.08, // 화면 세로 길이의 8% 크기의 아이콘
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
