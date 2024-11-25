import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class ClassPriceInputTile extends StatelessWidget {
  const ClassPriceInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.classNameController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController classNameController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == positionIndex
          ? Column(
              children: [
                TextField(
                  controller: classNameController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "수업료는 얼마인가요?",
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
