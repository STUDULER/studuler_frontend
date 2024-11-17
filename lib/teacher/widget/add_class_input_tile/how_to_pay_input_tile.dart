import 'package:flutter/material.dart';

import '../../../common/util/gesture_dectector_hiding_keyboard.dart.dart';

class HowToPayInputTile extends StatefulWidget {
  const HowToPayInputTile({
    super.key,
    required this.currIndex,
    required this.positionIndex,
    required this.beforeButton,
    required this.nextButton,
    required this.onPressed,
  });

  final int currIndex;
  final int positionIndex;
  final Function onPressed;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  State<HowToPayInputTile> createState() => _HowToPayInputTileState();
}

class _HowToPayInputTileState extends State<HowToPayInputTile> {
  int buttonActivated = 0;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(
      milliseconds: 100,
    );
    return Expanded(
      child: widget.currIndex == widget.positionIndex
          ? Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    TextButton.icon(
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                          Colors.black87,
                        ),
                        overlayColor: MaterialStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        widget.onPressed("선불");
                        buttonActivated = 1;
                      },
                      icon: AnimatedContainer(
                        duration: duration,
                        curve: Curves.bounceInOut,
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffffec9e),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: buttonActivated == 1
                              ? const Color(0xffffec9e)
                              : Colors.white70,
                        ),
                      ),
                      label: const Text("선불"),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    TextButton.icon(
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                          Colors.black87,
                        ),
                        overlayColor: MaterialStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        widget.onPressed("후불");
                        buttonActivated = 2;
                      },
                      icon: AnimatedContainer(
                        duration: duration,
                        curve: Curves.bounceInOut,
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffffec9e),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: buttonActivated == 2
                              ? const Color(0xffffec9e)
                              : Colors.white70,
                        ),
                      ),
                      label: const Text("후불"),
                    ),
                    const Spacer(),
                  ],
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
