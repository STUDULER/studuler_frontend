import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../http/http_service.dart';
import '../model/class_day.dart';
import '../util/weeks_of_month_calendar.dart';
import '../../common/section/calendar_week_section.dart';

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
    required this.onDateSelected, // 날짜 클릭 시 호출할 콜백 추가
  });

  final int classId;
  final Jiffy date;
  final bool? someWeeksOfNextMonth;
  final ValueNotifier<bool> weekMode;
  final ValueNotifier<Jiffy> selectedDate;
  final List<ClassDay> classDays;
  final Function(Jiffy) fetchClassDaysFunction;
  final Function(String) onDateSelected; // 클릭된 날짜를 부모에게 전달하는 콜백

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final httpService = HttpService();

  final sidePadding = const EdgeInsets.symmetric(horizontal: 12);

  Jiffy lastFetchTime = Jiffy.now();

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

    if (colorIdx >= 0 && colorIdx < colorPalette.length) {
      return colorPalette[colorIdx];
    } else {
      return const Color(0xFF000000); // Default black color
    }
  }

  @override
  void initState() {
    super.initState();
    // _logClassDays();
  }

  // 디버깅 메시지를 추가하여 classDays 정보를 로깅
  void _logClassDays() {
    print("Initializing CalendarWidget...");
    print("Class ID: ${widget.classId}");
    print("Selected Date: ${widget.selectedDate.value.format(pattern: 'yyyy-MM-dd')}");
    print("Class Days Loaded: ${widget.classDays.length}");
    for (var day in widget.classDays) {
      print(
          "ClassDay -> Date: ${day.day.format(pattern: 'yyyy-MM-dd')}, ColorIdx: ${day.colorIdx}");
    }
    print("Initialization complete.\n");
  }

  @override
  Widget build(BuildContext context) {
    List<CalendarWeekSection> weekSections = [];

    for (var i = 0; i < weeksOfMonthOnCalendar(widget.date); i++) {
      final weekStart = widget.date.startOf(Unit.month).startOf(Unit.week).add(weeks: i);

      weekSections.add(
        CalendarWeekSection(
          onTap: (int index, Jiffy date) {
            setState(() {
              widget.selectedDate.value = date;
            });
            print("Date selected: ${date.format(pattern: 'yyyy-MM-dd')}");
            fetchClassDetailsByDate(date.format(pattern: 'yyyy-MM-dd'));
            widget.onDateSelected(date.format(pattern: 'yyyy-MM-dd')); // 부모로 날짜 전달
          },
          allowLongPress: true,
          afterAddOrDeleteClassDay: widget.fetchClassDaysFunction,
          classId: widget.classId,
          selectedDate: widget.selectedDate.value,
          month: widget.date.month,
          startDayOfWeek: weekStart,
          classDays: widget.classDays.map((classDay) {
            /*
            print(
                "Mapping ClassDay: Date: ${classDay.day.format(pattern: 'yyyy-MM-dd')}, ColorIdx: ${classDay.colorIdx}");

             */
            return ClassDay(
              classId: classDay.classId,
              day: classDay.day,
              isPayDay: classDay.isPayDay,
              colorIdx: classDay.colorIdx, // 매핑된 색상 사용
            );
          }).toList(),
        ),
      );
    }

    if (widget.someWeeksOfNextMonth == true) {
      const numOfWeeksToDisplay = 8;
      final numOfSomeWeeks =
          numOfWeeksToDisplay - weeksOfMonthOnCalendar(widget.date);
      final Jiffy nextDate = widget.date.add(months: 1);

      print("Adding Overflow Weeks from Next Month: $numOfSomeWeeks");

      weekSections.addAll(
        List.generate(
          numOfSomeWeeks,
              (index) => CalendarWeekSection(
            classId: widget.classId,
            month: nextDate.month,
            selectedDate: widget.selectedDate.value,
            startDayOfWeek: nextDate
                .startOf(Unit.month)
                .startOf(Unit.week)
                .add(weeks: index),
            opacity: 0.33,
            classDays: const [],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final parentHeight = constraints.maxHeight;
        final componentHeight = parentHeight / weekSections.length;

        print("Final Layout: ${weekSections.length} weeks, Component Height: $componentHeight");

        return Stack(
          children: List<Widget>.generate(weekSections.length, (index) {
            final topPosition = componentHeight * index;

            print("Positioning Week Section $index at Top: $topPosition");

            return Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              height: componentHeight,
              child: ValueListenableBuilder(
                valueListenable: widget.selectedDate,
                builder: (context, selectedDate, child) {
                  return weekSections.elementAt(index);
                },
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> fetchClassDetailsByDate(String date) async {
    try {
      print("Fetching class details for date: $date...");
      final response = await httpService.call.get(
        '/total/classByDateT',
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200) {
        final List classDetails = response.data;
        print("Fetched ${classDetails.length} classes for date: $date.");
        for (var detail in classDetails) {
          print(
              "ClassId: ${detail['classid']}, ClassName: ${detail['classname']}, "
                  "ThemeColor: ${detail['themecolor']}, FeedbackStatus: ${detail['feedbackStatus']}");
        }
      } else {
        print(
            "Failed to fetch class details for date: $date. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching class details for date: $date -> $e");
    }
  }
}
