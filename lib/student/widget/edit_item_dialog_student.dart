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
    TextEditingController controller =
        TextEditingController(text: initialValue);

    Widget _buildInputField() {
      switch (title) {
        case '선생님 이름':
        case '수업 이름':
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
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
            ),
          );
        case '테마 색상':
          final List<Color> themeColors = [
            const Color(0xFFC96868),
            const Color(0xFFFFBB70),
            const Color(0xFFB5C18E),
            const Color(0xFFCFEFFC),
            const Color(0xFF5A72A0),
            const Color(0xFFDDBCFF),
            const Color(0xFFFCCFCF),
            const Color(0xFFD9D9D9),
            const Color(0xFF545454),
            const Color(0xFFB28F65),
          ];

          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
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
                                    controller.text = "$index";
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: themeColors[index],
                                  radius: 15,
                                  child: controller.text == "$index"
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
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
                                    controller.text = "${index + 5}";
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: themeColors[index + 5],
                                  radius: 15,
                                  child: controller.text == "${index + 5}"
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
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
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '$title 수정',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFC7B7A3).withOpacity(0.34),
                              foregroundColor: const Color(0xFFC7B7A3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("취소"),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                            onPressed: () async {
                              String newValue = controller.text;
                              print('새로운 값: $newValue');
                              bool success = false;

                              switch (title) {
                                case '선생님 이름':
                                  success =
                                      await HttpService().updateTeacherNameS(
                                    classId: classId,
                                    teacherName: newValue,
                                  );
                                  break;
                                case '수업 이름':
                                  success =
                                      await HttpService().updateClassNameS(
                                    classId: classId,
                                    className: newValue,
                                  );
                                  break;
                                case '테마 색상':
                                  success =
                                      await HttpService().updateThemeColorS(
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
                        ),
                      ],
                    ),
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
        );
      },
    );
  }

  static void showSelectItemDialog({
    required BuildContext context,
    required Map<String, dynamic> classData,
    required List<Map<String, dynamic>> items,
  }) {
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
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text(
                        "수정할 항목을 선택하세요",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
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
                    ),
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
        );
      },
    );
  }
}
