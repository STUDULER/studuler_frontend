import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../util/gesture_dectector_hiding_keyboard.dart.dart';

Future<void> showStudulerDialog(
  BuildContext context,
  String title,
  Widget? content,
  VoidCallback onCompleted, {
  double? height,
  bool showButton = true,
}) async {
  await showDialog(
    context: context,
    builder: (_) => GestureDectectorHidingKeyboard(
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            return Container(
              height: height ?? 170,
              width: 240,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (content == null) const Gap(24),
                  if (content != null) Gap(8),
                  if (content != null) content,
                  if (content != null) Gap(8),
                  if (showButton)
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 48,
                            height: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFC7B7A3).withOpacity(
                                0.34,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  color: Color(0xFFC7B7A3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        GestureDetector(
                          onTap: onCompleted,
                          child: Container(
                            width: 48,
                            height: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFC7B7A3),
                            ),
                            child: const Center(
                              child: Text(
                                "확인",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
