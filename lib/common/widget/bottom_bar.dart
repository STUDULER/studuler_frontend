import 'package:flutter/material.dart';

import '../../main.dart';
import '../../teacher/page/teacher_schedule_per_class_page.dart';
import '../../teacher/page/teacher_settlement_page.dart';
import '../page/drawer_page.dart';
import '../page/teacher_home_page.dart';
import '../page/teacher_schedule_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  bool perClassMode = false;
  String className = "";
  int classId = 0;
  int classColor = 0;

  void _onItemTapped(int index) {
    setState(() {
      perClassMode = false;
      _selectedIndex = index;
    });
  }

  void goToTeaccherSchedulPerClassPage(
    int classId,
    String className,
    int classColor,
  ) {
    setState(() {
      _selectedIndex = 0;
      perClassMode = true;
      this.classId = classId;
      this.className = className;
      this.classColor = classColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      if (perClassMode)
        TeacherSchedulePerClassPage(
          className: className,
          classId: classId,
          classColor: classColor,
        )
      else
        TeacherSchedulePage(goToPerClassPage: goToTeaccherSchedulPerClassPage,),
      TeacherHomePage(
        goToPerClassPage: goToTeaccherSchedulPerClassPage,
      ),
      const TeacherSettlementPage(),
    ];

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return WillPopScope(
      onWillPop: () async {
        if (perClassMode) {
          setState(() {
            perClassMode = false; // 뒤로가기 시 전체 캘린더로 전환
          });
          return false; // 뒤로가기 동작 중단 (앱 종료 방지)
        }
        return true; // 뒤로가기 허용 (앱 종료)
      },
      child: Scaffold(
        key: mainScaffoldKey,
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFFC7B7A3), // 선택된 아이템 색상
          unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: '스케줄',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: '정산하기',
            ),
          ],
        ),
        endDrawer: DrawerPage(),
      ),
    );
  }
}
