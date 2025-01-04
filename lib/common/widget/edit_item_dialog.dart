import 'package:flutter/material.dart';

class EditItemDialog {
  static void showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onUpdate,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$title 수정'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '새로운 값을 입력하세요',
            ),
          ),
          actions: [
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
        );
      },
    );
  }

  /// 항목 선택 다이얼로그를 표시하는 메서드
  static void showSelectItemDialog({
    required BuildContext context,
    required List<Map<String, dynamic>> items,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("수정할 항목을 선택하세요"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              return ListTile(
                title: Text(item['title']),
                onTap: () {
                  Navigator.pop(context);
                  showEditDialog(
                    context: context,
                    title: item['title'],
                    initialValue: item['controller'].text,
                    onUpdate: (newValue) {
                      item['onUpdate'](newValue);
                    },
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
