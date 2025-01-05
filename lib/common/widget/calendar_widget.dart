import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../http/http_service.dart';
import '../model/class_day.dart';
import '../util/weeks_of_month_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.classId,
    required this.date,
    this.someWeeksOfNextMonth = false,
    required this.weekMode,
    required this.selectedDate,
    required this.classDays,
    required this.fetchClassDaysFunction,
    required this.onDateSelected,
  });

  final int classId;
  final Jiffy date;
  final bool? someWeeksOfNextMonth;
  final ValueNotifier<bool> weekMode;
  final ValueNotifier<Jiffy> selectedDate;
  final List<ClassDay> classDays;
  final Function(Jiffy) fetchClassDaysFunction;
  final Function(String) onDateSelected;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final httpService = HttpService();

  // 색상 매핑 함수
  Color getColorFromIndex(int colorIdx) {
    const List<Color> colorPalette = [
      Color(0xFFC96868), // Red shade
      Color(0xFFFFBB70), // Peach shade
      Color(0xFFB5C18E), // Green shade
      Color(0xFFCFEFFC), // Light Blue shade
      Color(0xFF5A72A0), // Blue shade
      Color(0xFFDDBCFF), // Lavender shade
      Color(0xFFFCCFCF), // Pink shade
      Color(0xFFD9D9D9), // Light Gray shade
      Color(0xFF545454), // Dark Gray shade
      Color(0xFFB28F65), // Brown shade
    ];

    if (colorIdx < 0 || colorIdx >= colorPalette.length) {
      return const Color(0xFF000000); // Default black color
    }

    return colorPalette[colorIdx];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentHeight = constraints.maxHeight;
        final weekSections = weeksOfMonthOnCalendar(widget.date);

        return Column(
          children: List.generate(weekSections, (weekIndex) {
            final startDayOfWeek = widget.date.startOf(Unit.month).startOf(Unit.week).add(weeks: weekIndex);
            final daysInWeek = List.generate(7, (dayIndex) => startDayOfWeek.add(days: dayIndex));

            return Expanded(
              child: Row(
                children: daysInWeek.map((day) {
                  final matchingDays = widget.classDays
                      .where((classDay) => classDay.day.isSame(day, unit: Unit.day))
                      .toList();

                  // 점 색상 리스트 생성
                  final dotColors = matchingDays.map((classDay) => getColorFromIndex(classDay.colorIdx)).toList();

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedDate.value = day;
                        });
                        widget.onDateSelected(day.format(pattern: 'yyyy-MM-dd'));
                      },
                      child: Container(
                        color: Colors.transparent, // 셀 전체를 터치 가능하게 만듦
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 날짜 표시
                            Container(
                              width: MediaQuery.of(context).size.width / 7,
                              decoration: BoxDecoration(
                                color: day.isSame(widget.selectedDate.value, unit: Unit.day)
                                    ? const Color(0xffc7b7a3) // 클릭한 날짜: 갈색 동그라미
                                    : day.isSame(Jiffy.now(), unit: Unit.day)
                                    ? const Color(0xffc7b7a3).withOpacity(0.6) // 오늘 날짜: 투명도 낮은 갈색
                                    : Colors.white, // 나머지 날짜: 흰색 배경
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${day.date}",
                                    style: TextStyle(
                                      color: day.month == widget.date.month
                                          ? Colors.black
                                          : Colors.grey, // 다음 달/이전 달은 회색
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // 점 표시
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(dotColors.length, (index) {
                                return Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dotColors[index],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }
}
