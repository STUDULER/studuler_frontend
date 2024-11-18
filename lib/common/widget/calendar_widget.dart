import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final List<Map<String, dynamic>> classData; // 클래스 데이터 리스트 추가

  const CalendarWidget({Key? key, required this.classData}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  // 각 날짜에 표시할 수업을 반환
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    // 예시: 8일과 15일에 수업이 있다고 가정
    if (day.day == 8) {
      return [widget.classData[0]]; // '대치동 수학 과외'를 8일에 표시
    } else if (day.day == 15) {
      return [widget.classData[1]]; // '서초동 영어 과외'를 15일에 표시
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 년도와 월 선택
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: selectedYear,
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue!;
                  _focusedDay = DateTime(selectedYear, selectedMonth);
                });
              },
              items: [for (int i = 2020; i <= 2030; i++) i]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value년'),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: selectedMonth,
              onChanged: (int? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                  _focusedDay = DateTime(selectedYear, selectedMonth);
                });
              },
              items: List.generate(12, (index) => index + 1)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value월'),
                );
              }).toList(),
            ),
          ],
        ),
        // 캘린더 위젯
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
            ),
            calendarBuilders: CalendarBuilders(
              // 수업별로 다른 색상의 마커 표시
              singleMarkerBuilder: (context, date, event) {
                final classInfo = event as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: classInfo['themeColor'],
                    shape: BoxShape.circle,
                  ),
                  width: 6,
                  height: 6,
                );
              },
            ),
            eventLoader: _getEventsForDay,
          ),
        ),
      ],
    );
  }
}
