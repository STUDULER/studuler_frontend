import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/http/http_service.dart';

import '../model/class_day.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.classId,
    required this.date,
    required this.activated,
    this.opacity = 1.0,
    this.classDay,
    this.onTap,
    this.afterAddOrDeleteClassDay,
  });

  final int classId;

  final Function? onTap;
  final Function(Jiffy)? afterAddOrDeleteClassDay;

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
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                content: Builder(
                  builder: (context) {
                    return Container(
                      height: 120,
                      width: 200,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                          const Gap(8),
                          if (classDay == null)
                            const Text(
                              "수업을 추가하시겠습니까?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (classDay != null)
                            const Text(
                              "수업을 삭제하시겠습니까?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const Gap(24),
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 48,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFC7B7A3).withOpacity(
                                      0.34,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "취소",
                                      style: TextStyle(
                                        color: Color(0xFFC7B7A3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(8),
                              GestureDetector(
                                onTap: () async {
                                  final httpService = HttpService();
                                  if (classDay == null) {
                                    final rst = await httpService.addClassDay(
                                      classId: classId,
                                      date: date,
                                    );
                                    print(rst);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    final rst =
                                        await httpService.deleteClassDay(
                                      classId: classId,
                                      date: date,
                                    );
                                    print(rst);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                  if (afterAddOrDeleteClassDay != null) {
                                    afterAddOrDeleteClassDay!(date);
                                  }
                                },
                                child: Container(
                                  width: 48,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFC7B7A3),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
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
