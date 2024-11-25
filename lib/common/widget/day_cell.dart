import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.activated,
    this.opacity = 1.0,
  });

  final bool activated;
  final Jiffy date;
  final double opacity;

  final double dotSize = 6.0;
  final double gapSize = 2.5;

  // final List<Colors>

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (activated && opacity == 1.0) {
            print("tap!!!");
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
                      // color: Colors.red
                      color: date.isSame(Jiffy.now(), unit: Unit.day)
                          ? const Color(0xffc7b7a3).withOpacity(0.6)
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      // color: Color
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
                  Gap(1),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: dotSize,
                        height: dotSize,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.,
                        //   border: Border.all(
                        //     color: Colors.yellow,
                        //     width: 1.0
                        //   ),
                        //   color: Colors.blueGrey,
                        // ),
                        child: Icon(
                          size: dotSize,
                          Icons.star),
                      ),
                      Gap(gapSize),
                      Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      Gap(gapSize),
                      Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     const Spacer(),
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.purple.shade300,
                  //       ),
                  //     ),
                  //     const Gap(1),
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //     const Gap(1),
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //   ],
                  // ),
                  // Gap(1),
                  // Row(
                  //   children: [
                  //     const Spacer(),
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         border: Border.all(width: 2),
                  //         shape: BoxShape.circle,
                  //         color: Colors.purple.shade300,
                  //       ),
                  //     ),
                  //     const Gap(1),
                  //     Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.purple.shade300,
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //   ],
                  // ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
