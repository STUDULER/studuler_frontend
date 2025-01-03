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

  void _onItemTapped(int index) {
    perClassMode = false;
    setState(() {
      _selectedIndex = index;
    });
  }

  void goToTeaccherSchedulPerClassPage(String className) {
    perClassMode = true;
    this.className = className;
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      if (perClassMode)
        TeacherSchedulePerClassPage(
          className: className,
        )
      else
        const TeacherSchedulePage(),
      TeacherHomePage(
        goToPerClassPage: goToTeaccherSchedulPerClassPage,
      ),
      const TeacherSettlementPage(),
    ];

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      key: mainScaffoldKey,
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: const Color(0xFFC7B7A3), // 선택된 아이템의 색상
              unselectedItemColor: Colors.grey, // 선택되지 않은 아이템의 색상
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
    );
  }
}
