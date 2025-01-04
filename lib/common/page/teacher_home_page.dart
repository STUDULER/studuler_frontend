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

  final Function(String) goToPerClassPage;

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  Future<List<Map<String, dynamic>>>? futureClassData;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshClassData();
  }

  void _refreshClassData() {
    setState(() {
      futureClassData = null; // 먼저 future를 null로 초기화
    });

    // 새로운 데이터를 가져와 future에 할당
    Future.delayed(Duration.zero, () {
      setState(() {
        futureClassData = HttpService().fetchClasses();
      });
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
                  // AddClassPage로 이동하고 돌아올 때 데이터 갱신
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClassPage(),
                    ),
                  );
                  if (result != null && result == true) {
                    _refreshClassData(); // 데이터를 갱신
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
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                final classData = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.13), // 상단 여백 비율 유지
                    // 인디케이터
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(classData.length, (index) {
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
                    SizedBox(height: screenHeight * 0.06), // 인디케이터 아래 여백 비율 유지
                    Expanded(
                      child: Swiper(
                        itemCount: classData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final classItem = classData[index];
                          return ClassInfoCard(
                            title: classItem['title'],
                            code: classItem['code'],
                            classId: classItem['classId'],
                            currentIndex: index,
                            totalCards: classData.length,
                            completionRate: classItem['completionRate'],
                            themeColor: classItem['themeColor'],
                            infoItems: classItem['infoItems'],
                            onUpdate: (updatedTitle, updatedInfoItems, updatedThemeColor) {
                              setState(() {
                                classData[index]['title'] = updatedTitle;
                                classData[index]['infoItems'] = updatedInfoItems;
                                classData[index]['themeColor'] = updatedThemeColor;
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
                return const Center(child: Text('수업 데이터가 없습니다.'));
              }
            },
          )
        ],
      ),
    );
  }
}
