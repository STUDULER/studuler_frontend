import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../http/http_service.dart';

class EditItemDialog {
  static void showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onUpdate,
    required int classId, // classId를 부모에서 전달받음
    bool isNumeric = false,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

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
                      TextField(
                        controller: controller,
                        keyboardType: isNumeric
                            ? TextInputType.number
                            : TextInputType.text,
                        inputFormatters: isNumeric
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
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
                            onPressed: () async {
                              String newValue = controller.text;
                              bool success = false;

                              // 엔드포인트 호출
                              switch (title) {
                                case '학생 이름':
                                  success = await HttpService().updateStudentName(
                                    classId: classId,
                                    studentName: newValue,
                                  );
                                  break;
                                case '수업 이름':
                                  success = await HttpService().updateClassName(
                                    classId: classId,
                                    className: newValue,
                                  );
                                  break;
                                case '요일':
                                  success = await HttpService().updateDay(
                                    classId: classId,
                                    day: newValue,
                                  );
                                  break;
                                case '회당 시간':
                                  success = await HttpService().updateTime(
                                    classId: classId,
                                    time: int.parse(newValue),
                                  );
                                  break;
                                case '수업 횟수':
                                  success = await HttpService().updatePeriod(
                                    classId: classId,
                                    period: int.parse(newValue),
                                  );
                                  break;
                                case '시급':
                                  success = await HttpService().updateHourlyRate(
                                    classId: classId,
                                    hourlyRate: int.parse(newValue),
                                  );
                                  break;
                                case '선불/후불':
                                  success = await HttpService().updatePrepay(
                                    classId: classId,
                                    prepay: int.parse(newValue),
                                  );
                                  break;
                                case '테마 색상':
                                  success = await HttpService().updateThemeColor(
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
                                isNumeric: item['title'] == '회당 시간',
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
