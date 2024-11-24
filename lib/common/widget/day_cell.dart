import 'package:flutter/material.dart';
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
                        color: date.isSame(Jiffy.now(), unit: Unit.day)
                            ? const Color(0xffc7b7a3).withOpacity(0.6)
                            : Colors.white,
                        shape: BoxShape.circle),
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
                  // const Placeholder(),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
