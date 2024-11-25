import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class ClassStartDateInputTile extends StatelessWidget {
  const ClassStartDateInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.classStartDateController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController classStartDateController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == positionIndex
          ? Column(
              children: [
                TextField(
                  controller: classStartDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "수업 시작일은 언제 인가요?",
                  ),
                  onTap: () async {
                    final result = await showBoardDateTimePicker(
                      context: context,
                      pickerType: DateTimePickerType.date,
                      barrierColor: Colors.transparent,
                      options: BoardDateTimeOptions(
                        boardTitle: "수업 시작일",
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.white70,
                        activeColor: Colors.grey.shade500,
                        activeTextColor: Colors.black87,
                        textColor: Colors.black,
                        inputable: false,
                        languages: const BoardPickerLanguages(
                          locale: "ko",
                          today: "오늘",
                          tomorrow: "내일",
                          now: "현재",
                        ),
                      ),
                    );
                    if (result != null) {
                      classStartDateController.text =
                          result.toString().split(" ",).first;
                    }
                  },
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
