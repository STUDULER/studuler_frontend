import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class ClassThemeColorInputTile extends StatefulWidget {
  const ClassThemeColorInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.themeColorController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final int positionIndex;
  final TextEditingController themeColorController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  State<ClassThemeColorInputTile> createState() =>
      _ClassThemeColorInputTileState();
}

class _ClassThemeColorInputTileState extends State<ClassThemeColorInputTile> {
  final List<Color> themeColors = [
    const Color(0xFFC96868), // Red shade
    const Color(0xFFFFBB70), // Peach shade
    const Color(0xFFB5C18E), // Green shade
    const Color(0xFFCFEFFC), // Light Blue shade
    const Color(0xFF5A72A0), // Blue shade
    const Color(0xFFDDBCFF), // Lavender shade
    const Color(0xFFFCCFCF), // Pink shade
    const Color(0xFFD9D9D9), // Light Gray shade
    const Color(0xFF545454), // Dark Gray shade
    const Color(0xFFB28F65), // Brown shade
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.currIndex == widget.positionIndex
          ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                          (index) => selectableColorCircle(
                            index,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          5,
                          (index) => selectableColorCircle(
                            index + 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
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

  GestureDetector selectableColorCircle(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.themeColorController.text = "$index";
        });
      },
      child: CircleAvatar(
        backgroundColor: themeColors.elementAt(index),
        radius: 15,
        child: widget.themeColorController.text == "$index"
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}
