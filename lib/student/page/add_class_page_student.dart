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

    // 초기 텍스트 설정
    classCodeController.text = "수업 코드를 입력해주세요";

    // 포커스 상태 변화에 따라 기본 텍스트 처리
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

    // 입력된 글자 수 추적
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

  void joinClass() async {
    final String classCode = classCodeController.text.trim();

    if (classCode.isEmpty || classCode == "수업 코드를 입력해주세요") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("유효한 수업 코드를 입력해주세요."),
        ),
      );
      return;
    }

    final String? responseMessage = await httpService.joinClass(classCode: classCode);

    if (responseMessage != null && responseMessage.contains("Successfully")) {
      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("수업에 성공적으로 참여했습니다!"),
          backgroundColor: Colors.green,
        ),
      );
      if (context.mounted) Navigator.pop(context, true); // 성공 시 true 반환
    } else {
      // 실패 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseMessage ?? "수업 참여에 실패했습니다."),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    width: MediaQuery.of(context).size.width, // 화면 너비 설정
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
                        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
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
                          const SizedBox(height: 6), // "수업 코드"와 TextField 사이 간격 추가
                          Align(
                            alignment: Alignment.center, // TextField를 화면 가운데로 정렬
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85, // 가로 길이 조정
                              child: TextField(
                                controller: classCodeController,
                                focusNode: classCodeFocusNode,
                                maxLength: 8, // 최대 글자 수 제한
                                textAlign: TextAlign.left, // 입력 텍스트는 왼쪽 정렬
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(), // 밑줄 추가
                                  counterText: classCodeController.text ==
                                      "수업 코드를 입력해주세요"
                                      ? "$currentTextLength/8"
                                      : "$currentTextLength/8",
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
                    onTap: joinClass, // 버튼 클릭 시 joinClass 함수 실행
                    child: Container(
                      width: double.infinity, // 버튼 너비를 전체로 설정
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
