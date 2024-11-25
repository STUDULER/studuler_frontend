import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class HoursPerClassInputTile extends StatelessWidget {
  const HoursPerClassInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.hoursPerClassController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController hoursPerClassController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == positionIndex
          ? Column(
              children: [
                TextField(
                  controller: hoursPerClassController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "회당 시간을 적어주세요 (1~6 사이 정수)",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Spacer(),
                    beforeButton,
                    const SizedBox(
                      width: 8,
                    ),
                    nextButton,
                  ],
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
