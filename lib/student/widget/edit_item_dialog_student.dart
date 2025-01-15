import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/http/http_service.dart';

class EditItemDialogStudent {
  static void showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onUpdate,
    required int classId,
    bool isNumeric = false,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    // 다이나믹한 입력 필드 생성 함수
    Widget _buildInputField() {
      switch (title) {
        case '선생님 이름':
        case '수업 이름':
          return TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: '새로운 값을 입력하세요',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          );
        case '테마 색상':
          final List<Color> themeColors = [
            const Color(0xFFC96868), // Red shade
            const Color(0xFFFFBB70), // Peach shade
            const Color(0xFFB5C18E), // Green shade
            const Color(0xFFCFEFFC), // Light Blue shade
            const Color(0xFF5A72A0), // Blue shade
            const Color(0xFFDDBCFF), // Lavender shade
            const Color(0xFFFCCFCF), // Pink shade
            const Color(0xFFD9D9D9), // Light Gray shade
            const Color(0xFF545454), // Dark Gray shade
            const Color(0xFFB28F65), // Brown shade
          ];

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            5,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.text = "$index"; // 선택된 색상 인덱스를 저장
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: themeColors[index],
                                radius: 15,
                                child: controller.text == "$index"
                                    ? const Icon(
                                  Icons.check,
                                  color: Colors.white, // 체크 아이콘 색상을 흰색으로 설정
                                  size: 16,
                                )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            5,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.text = "${index + 5}"; // 두 번째 줄 색상
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: themeColors[index + 5],
                                radius: 15,
                                child: controller.text == "${index + 5}"
                                    ? const Icon(
                                  Icons.check,
                                  color: Colors.white, // 체크 아이콘 색상을 흰색으로 설정
                                  size: 16,
                                )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        default:
          return const SizedBox();
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
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
                      Text(
                        '$title 수정',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(), // 동적으로 렌더링된 입력 필드
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () async {
                              String newValue = controller.text;
                              print('새로운 값: $newValue'); // 디버그 로그 추가
                              bool success = false;

                              // 엔드포인트 호출
                              switch (title) {
                                case '선생님 이름':
                                  success = await HttpService().updateTeacherNameS(
                                    classId: classId,
                                    teacherName: newValue,
                                  );
                                  break;
                                case '수업 이름':
                                  success = await HttpService().updateClassNameS(
                                    classId: classId,
                                    className: newValue,
                                  );
                                  break;
                                case '테마 색상':
                                  success = await HttpService().updateThemeColorS(
                                    classId: classId,
                                    themeColor: int.parse(newValue),
                                  );
                                  break;
                              }

                              if (success) {
                                onUpdate(newValue);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("수정이 완료되었습니다.")),
                                );
                              } else {
                                print('수업 수정 실패: $title with value: $newValue'); // 실패 로그
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("수정에 실패했습니다."),
                                  ),
                                );
                              }
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.map((item) {
                          return ListTile(
                            title: Text(item['title']),
                            onTap: () {
                              Navigator.pop(context);
                              final initialValue = item['controller'].text;
                              showEditDialog(
                                context: context,
                                title: item['title'],
                                initialValue: initialValue,
                                onUpdate: item['onUpdate'],
                                classId: classData['classid'],
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
