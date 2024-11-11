import 'package:flutter/material.dart';

import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/background.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  int currIndex = 0;
  TextEditingController classNameController = TextEditingController();
  TextEditingController numOfClassesToPayController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    classNameController.dispose();
    numOfClassesToPayController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(
      milliseconds: 300,
    );
    var beforeButton = GestureDectectorHidingKeyboard(
      onTap: () {
        setState(() {
          currIndex--;
        });
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("이전"),
        ),
      ),
    );

    var nextButton = GestureDectectorHidingKeyboard(
      onTap: () {
        setState(() {
          currIndex++;
        });
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("다음"),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          const Background(
            iconActionButtons: [],
          ),
          Column(
            children: [
              const SizedBox(height: 140),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: currIndex == 0
                                ? const Color(0xffffec9e)
                                : Colors.white70,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "수업이름",
                            style: TextStyle(
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
                          height: currIndex == 0 ? 80 : 30,
                          color: const Color(0xFFC7B7A3),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        ClassNameInputTile(
                          currIndex: currIndex,
                          classNameController: classNameController,
                          nextButton: nextButton,
                        ),
                      ],
                    ),
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
                            // color: const Color(0xffffec9e),
                            color: Colors.transparent,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "수업료 납부 횟수",
                            style: TextStyle(
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
                          height: currIndex == 1 ? 80 : 30,
                          color: const Color(0xFFC7B7A3),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        NumberOfClassesToPayInputTile(
                          currIndex: currIndex,
                          classNameController: numOfClassesToPayController,
                          beforeButton: beforeButton,
                          nextButton: nextButton,
                        ),
                      ],
                    ),
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
                            color: (currIndex == 2)
                                ? const Color(0xffffec9e)
                                : Colors.transparent,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "수업료",
                            style: TextStyle(
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
                          height: currIndex == 1 ? 80 : 30,
                          color: const Color(0xFFC7B7A3),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        ClassPriceInputTile(
                          currIndex: currIndex,
                          classNameController: numOfClassesToPayController,
                          beforeButton: beforeButton,
                          nextButton: nextButton,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClassNameInputTile extends StatelessWidget {
  const ClassNameInputTile({
    super.key,
    required this.currIndex,
    required this.classNameController,
    required this.nextButton,
  });

  final int currIndex;
  final TextEditingController classNameController;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == 0
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

class NumberOfClassesToPayInputTile extends StatelessWidget {
  const NumberOfClassesToPayInputTile({
    super.key,
    required this.currIndex,
    required this.classNameController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final TextEditingController classNameController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == 1
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

class ClassPriceInputTile extends StatelessWidget {
  const ClassPriceInputTile({
    super.key,
    required this.currIndex,
    required this.classNameController,
    required this.beforeButton,
    required this.nextButton,
  });

  final int currIndex;
  final TextEditingController classNameController;
  final GestureDectectorHidingKeyboard beforeButton;
  final GestureDectectorHidingKeyboard nextButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: currIndex == 2
          ? Column(
              children: [
                TextField(
                  controller: classNameController,
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
