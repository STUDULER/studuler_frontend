import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditItemDialog {
  static void showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onUpdate,
    required int classId,
    required Future<bool> Function(String) apiCall,
    bool isNumeric = false,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 22),
                Text(
                  '$title 수정',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
                  inputFormatters: isNumeric
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  decoration: const InputDecoration(
                    hintText: '새로운 값을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFC7B7A3).withOpacity(0.34),
                        foregroundColor: const Color(0xFFC7B7A3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        print("취소 버튼 클릭");
                        Navigator.pop(context);
                      },
                      child: const Text("취소"),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFC7B7A3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        final newValue = controller.text;
                        print("저장 버튼 클릭: 입력된 값 = $newValue");

                        try {
                          final success = await apiCall(newValue);
                          print("API 호출 결과: $success");

                          if (success) {
                            onUpdate(newValue);
                            Navigator.pop(context);
                          } else {
                            print("API 호출 실패");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("수정 실패!")),
                            );
                          }
                        } catch (e) {
                          print("API 호출 중 오류 발생: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("오류 발생: $e")),
                          );
                        }
                      },
                      child: const Text("저장"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSelectItemDialog({
    required BuildContext context,
    required Map<String, dynamic> classData,
    required List<Map<String, dynamic>> items,
  }) {
    print("showSelectItemDialog 호출");
    print("classData: $classData");
    print("items: $items");

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 22),
                const Text(
                  "수정할 항목을 선택하세요",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Column(
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item['title']),
                      onTap: () {
                        print("항목 선택: ${item['title']}");
                        Navigator.pop(context);

                        // 초기 값 가져오기
                        final initialValue = item['controller'].text;
                        print("초기 값: $initialValue");

                        // classid를 int 타입으로 변환 (혹시 모를 타입 불일치 방지)
                        final classId = classData['classId'];
                        if (classId is! int) {
                          print("classid가 int가 아님. 현재 타입: ${classId.runtimeType}");
                          throw Exception("classid가 int가 아닙니다.");
                        } // 통과

                        // API 호출 함수 가져오기
                        final apiCall = item['apiCall'];
                        if (apiCall == null || apiCall is! Future<bool> Function(int, String)) {
                          print("apiCall이 올바르지 않음. 현재 타입: ${apiCall.runtimeType}");
                          throw Exception("apiCall이 올바르지 않습니다.");
                        }

                        // 수정 다이얼로그 표시
                        showEditDialog(
                          context: context,
                          title: item['title'],
                          initialValue: initialValue,
                          onUpdate: item['onUpdate'],
                          classId: classId,
                          apiCall: (newValue) {
                            print("API 호출 준비. classid: $classId, newValue: $newValue");
                            return apiCall(classId, newValue);
                          },
                          isNumeric: item['title'] == '회당 시간',
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
