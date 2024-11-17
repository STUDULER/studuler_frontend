import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class ClassScheduleInputTile extends StatefulWidget {
  const ClassScheduleInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  State<ClassScheduleInputTile> createState() => _ClassScheduleInputTileState();
}

class _ClassScheduleInputTileState extends State<ClassScheduleInputTile> {
  final List<String> selectedDays = [];
  final Color selectedBoxColor = const Color(0xFFC7B7A3); // 선택된 박스 색상
  final Color unselectedBoxColor =
      const Color(0x4DC7B7A3); // 선택되지 않은 박스 색상 (30% 투명도)
  final Color selectedTextColor = Colors.white; // 선택된 요일의 텍스트 색상
  final Color unselectedTextColor = const Color(0xFFC7B7A3);
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.currIndex == widget.positionIndex
          ? Column(
              children: [
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: ['월', '화', '수', '목', '금', '토', '일']
                      .map(
                        (day) => ChoiceChip(
                          label: Text(
                            day,
                            style: TextStyle(
                              color: selectedDays.contains(day)
                                  ? selectedTextColor
                                  : unselectedTextColor,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          selected: selectedDays.contains(day),
                          selectedColor: selectedBoxColor,
                          backgroundColor: unselectedBoxColor,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                              // widget.daysController.text =
                              //     getSortedDaysString();
                            });
                          },
                          showCheckmark: false,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Spacer(),
                    widget.beforeButton,
                    const SizedBox(
                      width: 8,
                    ),
                    widget.nextButton,
                  ],
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
