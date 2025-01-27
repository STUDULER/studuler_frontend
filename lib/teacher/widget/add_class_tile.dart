import 'package:flutter/material.dart';

class AddClassTile extends StatelessWidget {
  const AddClassTile({
    super.key,
    required this.currIdx,
    required this.positionIdx,
    required this.title,
    required this.inputTile,
    required this.height,
    required this.showErrorText,
  });

  final int currIdx;
  final int positionIdx;
  final String title;
  final Widget inputTile;
  final double height;
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    final errorTextStyle = TextStyle(fontSize: 12, color: Colors.red);
    const double foldedHeight = 15;
    assert(height >= foldedHeight);
    const duration = Duration(
      milliseconds: 300,
    );

    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: duration,
              curve: Curves.bounceInOut,
              width: 18,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: const Color(0xffffec9e),
                ),
                borderRadius: BorderRadius.circular(20),
                color: currIdx == positionIdx
                    ? const Color(0xffffec9e)
                    : Colors.white70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff383838),
                  ),
                  children: [
                    TextSpan(text: '$title '),
                    if (showErrorText)
                      TextSpan(
                        text: ' (필수 사항)',
                        style: errorTextStyle,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 7.5,
            ),
            AnimatedContainer(
              curve: Curves.bounceInOut,
              duration: duration,
              width: 2,
              height: currIdx == positionIdx ? height : foldedHeight,
              color: const Color(0xFFC7B7A3),
            ),
            const SizedBox(
              width: 32,
            ),
            inputTile,
          ],
        ),
      ],
    );
  }
}
