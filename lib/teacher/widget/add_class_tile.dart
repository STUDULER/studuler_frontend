import 'package:flutter/material.dart';

class AddClassTile extends StatelessWidget {
  const AddClassTile({
    super.key,
    required this.currIdx,
    required this.positionIdx,
    required this.title,
    required this.inputTile,
  });

  final int currIdx;
  final int positionIdx;
  final String title;
  final Widget inputTile;

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff383838),
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
              height: currIdx == positionIdx ? 80 : 30,
              color: const Color(0xFFC7B7A3),
            ),
            const SizedBox(
              width: 32,
            ),
            // ClassNameInputTile(
            //   currIndex: currIndex,
            //   classNameController: classNameController,
            //   nextButton: nextButton,
            // ),
            inputTile,
          ],
        ),
      ],
    );
  }
}
