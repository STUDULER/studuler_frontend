import 'package:flutter/material.dart';
import 'package:studuler/common/page/teacher_home_page.dart';
import 'package:studuler/common/page/teacher_schedule_page.dart';
import 'package:studuler/common/page/teacher_settlement_page.dart';

import '../page/drawer_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const TeacherSchedulePage(),
    const TeacherHomePage(),
    const TeacherSettlementPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      endDrawer: const DrawerPage(),
    );
  }
}
