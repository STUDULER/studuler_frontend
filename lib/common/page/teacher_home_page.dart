import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import '../../main.dart';
import '../../teacher/page/add_class_page.dart';
import '../http/http_service.dart';
import '../widget/class_info_card.dart';
import '../widget/background.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({
    super.key,
    required this.goToPerClassPage,
  });

  final Function(int, String, int) goToPerClassPage;

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
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
      futureClassData = HttpService().fetchClasses().then((data) {
        setState(() {
          classData = data; // 로컬에 데이터 저장
        });
        return data;
      });
    });
  }

  void _removeClass(int classId) {
    setState(() {
      classData?.removeWhere((classItem) => classItem['classId'] == classId);
      if (currentIndex >= (classData?.length ?? 1)) {
        currentIndex = (classData?.length ?? 1) - 1; // 인덱스 조정
      }
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
            iconActionButtons: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClassPage(),
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
                if (errorMessage.contains('No classes available for the teacher')) {
                  // 특정 에러 메시지일 경우 빈 카드 표시
                  return _buildEmptyCard(screenHeight, screenWidth);
                } else {
                  // 그 외의 에러는 에러 메시지 표시
                  return Center(child: Text('에러 발생: $errorMessage'));
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
                        itemCount: classData!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final classItem = classData![index];
                          return ClassInfoCard(
                            title: classItem['title'],
                            code: classItem['code'],
                            classId: classItem['classId'],
                            currentIndex: index,
                            totalCards: classData!.length,
                            completionRate: classItem['completionRate'],
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
                            onDelete: _removeClass, // 삭제 콜백 전달
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
              builder: (context) => const AddClassPage(),
            ),
          );
          if (result != null && result == true) {
            _refreshClassData();
          }
        },
        child: Container(
          width: screenWidth * 0.93, // 화면 가로 길이의 93%
          height: screenHeight * 0.67, // 화면 세로 길이의 67%
          margin: EdgeInsets.only(top: screenHeight * 0.22), // 카드 위치 아래로 이동
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
