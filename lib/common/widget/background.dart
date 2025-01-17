import 'package:flutter/material.dart';

import '../util/get_color_by_index.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.iconActionButtons,
    this.colorIndex,
    this.isTeacher = true,
    this.hasBackButton = false,
  });

  final bool isTeacher;
  final bool hasBackButton;
  final int? colorIndex;
  final List<IconButton> iconActionButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // 배경 높이
      decoration: BoxDecoration(
        color: colorIndex == null
            ? isTeacher
                ? Colors.yellow[200]
                : const Color(0xffB7CADB)
            : getColorByIndex(
                colorIndex!,
              ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40, // 원하는 위치로 조정
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (hasBackButton)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    const Text(
                      'STUDULER',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoetsenOne',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: iconActionButtons,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
