import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class ClassNameInputTile extends StatelessWidget {
  const ClassNameInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.classNameController,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController classNameController;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == positionIndex
          ? Column(
              children: [
                TextField(
                  controller: classNameController,
                  decoration: const InputDecoration(
                    hintText: "수업이름을 적어주세요",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [const Spacer(), nextButton],
                )
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}