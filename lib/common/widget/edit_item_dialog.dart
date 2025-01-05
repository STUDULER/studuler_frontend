import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditItemDialog {
  static void showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onUpdate,
    bool isNumeric = false, // 숫자 입력 전용 여부 추가
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // 살짝 둥근 모서리
          ),
          child: Container(
            color: Colors.white, // 배경색 흰색
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title 수정',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller,
                        keyboardType: isNumeric ? TextInputType.number : TextInputType.text, // 숫자 입력 전용 설정
                        inputFormatters: isNumeric
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null, // 숫자만 입력 가능하도록 필터 추가
                        decoration: const InputDecoration(
                          hintText: '새로운 값을 입력하세요',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              onUpdate(controller.text); // 새로운 값 업데이트
                              Navigator.pop(context);
                            },
                            child: const Text('저장'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
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
    required Map<String, dynamic> classData, // 클래스 데이터 전달
    required List<Map<String, dynamic>> items,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // 모서리 살짝 둥글게
          ),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "수정할 항목을 선택하세요",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.map((item) {
                          return ListTile(
                            title: Text(item['title']),
                            onTap: () {
                              Navigator.pop(context);

                              // "회당 시간"일 경우 classData['time'] 값을 초기 값으로 사용
                              final initialValue = item['title'] == '회당 시간'
                                  ? classData['time'].toString() // 단위 제거
                                  : item['controller'].text;

                              showEditDialog(
                                context: context,
                                title: item['title'],
                                initialValue: initialValue,
                                onUpdate: item['onUpdate'],
                                isNumeric: item['title'] == '회당 시간', // 숫자 입력 전용
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
