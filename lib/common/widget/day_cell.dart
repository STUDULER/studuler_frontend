import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../model/class_day.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.activated,
    this.opacity = 1.0,
    this.classDay,
    this.onTap,
  });

  final Function? onTap;

  final bool activated;
  final Jiffy date;
  final double opacity;

  final ClassDay? classDay;

  final double dotSize = 6.0;
  final double gapSize = 2.5;

  int getWeekOfMonth(Jiffy jiffy) {
    int sundayCnt = 0;
    Jiffy iter = jiffy.startOf(Unit.month);
    if (iter.dateTime.weekday == DateTime.sunday) sundayCnt -= 1;
    while (iter.isSameOrBefore(jiffy, unit: Unit.day)) {
      if (iter.dateTime.weekday == DateTime.sunday) sundayCnt += 1;
      iter = iter.add(days: 1);
    }
    return sundayCnt;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (activated && opacity == 1.0) {
            if (onTap != null) {
              onTap!(getWeekOfMonth(date), date);
            }
          }
        },
        onLongPress: () {
          if (activated && opacity == 1.0) {
            print("Long preess!!");
          }
        },
        child: activated
            ? Column(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width / 7,
                    decoration: BoxDecoration(
                      color: date.isSame(Jiffy.now(), unit: Unit.day)
                          ? const Color(0xffc7b7a3).withOpacity(0.6)
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${date.date}",
                          style: TextStyle(
                            color: Colors.black87.withOpacity(opacity),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(2),
                  if (classDay != null)
                    Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
