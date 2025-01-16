import 'package:flutter/material.dart';

import '../../common/http/http_service.dart';
import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/background.dart';

class AddClassPageStudent extends StatefulWidget {
  const AddClassPageStudent({super.key});

  @override
  State<AddClassPageStudent> createState() => _AddClassPageStudentState();
}

class _AddClassPageStudentState extends State<AddClassPageStudent> {
  final HttpService httpService = HttpService();

  TextEditingController classCodeController = TextEditingController();
  FocusNode classCodeFocusNode = FocusNode();
  int currentTextLength = 0;

  @override
  void initState() {
    super.initState();

    classCodeController.text = "수업 코드를 입력해주세요";

    classCodeFocusNode.addListener(() {
      if (classCodeFocusNode.hasFocus &&
          classCodeController.text == "수업 코드를 입력해주세요") {
        setState(() {
          classCodeController.clear();
        });
      } else if (!classCodeFocusNode.hasFocus &&
          classCodeController.text.isEmpty) {
        setState(() {
          classCodeController.text = "수업 코드를 입력해주세요";
        });
      }
    });

    classCodeController.addListener(() {
      if (classCodeController.text != "수업 코드를 입력해주세요") {
        setState(() {
          currentTextLength = classCodeController.text.length;
        });
      }
    });
  }

  @override
  void dispose() {
    classCodeController.dispose();
    classCodeFocusNode.dispose();
    super.dispose();
  }

  Future<void> joinClass() async {
    final String classCode = classCodeController.text.trim();

    if (classCode.isEmpty || classCode == "수업 코드를 입력해주세요") {
      await _showPopup(
        title: "수업 추가 오류",
        message: "유효한 수업 코드를 입력해주세요.",
        isError: true,
      );
      return;
    }

    final String? responseMessage = await httpService.joinClass(classCode: classCode);
    print(responseMessage);

    if (responseMessage != null && responseMessage.contains("Successfully")) {
      await _showPopup(
        title: "$classCode",
        message: "수업에 성공적으로 참여했습니다!",
        isError: false,
        onConfirm: () {
          if (context.mounted) Navigator.pop(context, true);
        },
      );
    } else {
      await _showPopup(
        title: "수업 추가 오류",
        message: "수업 코드를 다시 확인해주세요.",
        isError: true,
      );
    }
  }

  Future<void> _showPopup({
    required String title,
    required String message,
    bool isError = false,
    VoidCallback? onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFC7B7A3).withOpacity(0.34),
                            foregroundColor: const Color(0xFFC7B7A3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("취소"),
                        ),
                      ),
                      if (!isError) const SizedBox(width: 10),
                      if (!isError)
                        SizedBox(
                          width: 60,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFC7B7A3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (onConfirm != null) onConfirm();
                            },
                            child: const Text("확인"),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDectectorHidingKeyboard(
        child: Stack(
          children: [
            const Background(
              isTeacher: false,
              iconActionButtons: [],
            ),
            Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(64),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "수업 추가하기",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "수업 코드",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                controller: classCodeController,
                                focusNode: classCodeFocusNode,
                                maxLength: 8,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  counterText: "$currentTextLength/8",
                                  counterStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: GestureDectectorHidingKeyboard(
                    onTap: joinClass,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFC7B7A3),
                      ),
                      child: const Center(
                        child: Text(
                          "추가하기",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
