import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class StudentNameInputTile extends StatelessWidget {
  const StudentNameInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.studentNameController,
    required this.beforeButton,
    required this.nextButton, 
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController studentNameController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == positionIndex
          ? Column(
              children: [
                TextField(
                  controller: studentNameController,
                  decoration: const InputDecoration(
                    hintText: "학생 이름을 적어주세요",
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