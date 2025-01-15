import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../http/http_service.dart';

class EditItemDialog {
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
        case '학생 이름':
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
        case '회당 시간':
          return TextField(
            controller: TextEditingController(
              text: initialValue.replaceAll('시간', ''), // '시간' 제거
            ),
            keyboardType: TextInputType.number, // 숫자 입력 전용 키보드
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력 가능
            decoration: const InputDecoration(
              hintText: '회당 시간을 입력하세요',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (newValue) {
              controller.text = newValue; // 변경된 값을 controller에 저장
            },
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
        case '요일':
          final List<String> selectedDays = initialValue.split('/');
          final Color selectedBoxColor = const Color(0xFFC7B7A3); // 선택된 박스 색상
          final Color unselectedBoxColor =
          const Color(0x4DC7B7A3); // 선택되지 않은 박스 색상 (30% 투명도)
          final Color selectedTextColor = Colors.white; // 선택된 텍스트 색상
          final Color unselectedTextColor = const Color(0xFFC7B7A3);

          final Map<String, int> dayOrder = {
            '월': 1,
            '화': 2,
            '수': 3,
            '목': 4,
            '금': 5,
            '토': 6,
            '일': 7,
          };

          // 선택된 요일을 정렬하여 반환
          String getSortedDaysString() {
            selectedDays.sort((a, b) => dayOrder[a]!.compareTo(dayOrder[b]!));
            return selectedDays.join('/');
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Wrap(
                    runSpacing: 2.0, // 줄 간 간격
                    children: ['월', '화', '수', '목', '금', '토', '일']
                        .map(
                          (day) => ChoiceChip(
                        label: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12, // 텍스트 크기 조정
                            color: selectedDays.contains(day)
                                ? selectedTextColor
                                : unselectedTextColor,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, // 좌우 여백 줄이기
                          vertical: 2.0, // 상하 여백 줄이기
                        ),
                        selected: selectedDays.contains(day),
                        selectedColor: selectedBoxColor,
                        backgroundColor: unselectedBoxColor,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                            controller.text = getSortedDaysString();
                          });
                        },
                        showCheckmark: false,
                      ),
                    )
                        .toList(),
                  ),
                ],
              );
            },
          );
        case '정산 방법':
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              // 초기값을 기반으로 버튼 활성화 상태 설정
              int buttonActivated = controller.text == '선불' ? 1 : 0; // 1: 선불, 0: 후불

              const duration = Duration(milliseconds: 100);

              return Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      TextButton.icon(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                            Colors.black87,
                          ),
                          overlayColor: MaterialStatePropertyAll(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          controller.text = '1'; // UI 표시용 값 설정 (선불)
                          setState(() {
                            buttonActivated = 1; // 버튼 활성화 상태 업데이트
                          });
                          onUpdate('1'); // 변경된 값 전달
                        },
                        icon: AnimatedContainer(
                          duration: duration,
                          curve: Curves.bounceInOut,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: const Color(0xffffec9e),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: buttonActivated == 1
                                ? const Color(0xffffec9e)
                                : Colors.white70,
                          ),
                        ),
                        label: const Text("선불"),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      TextButton.icon(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                            Colors.black87,
                          ),
                          overlayColor: MaterialStatePropertyAll(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          controller.text = '0'; // UI 표시용 값 설정 (후불)
                          setState(() {
                            buttonActivated = 0; // 버튼 활성화 상태 업데이트
                          });
                          onUpdate('0'); // 변경된 값 전달
                        },
                        icon: AnimatedContainer(
                          duration: duration,
                          curve: Curves.bounceInOut,
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: const Color(0xffffec9e),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: buttonActivated == 0
                                ? const Color(0xffffec9e)
                                : Colors.white70,
                          ),
                        ),
                        label: const Text("후불"),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              );
            },
          );
      // 시급
        case '시급':
          return TextField(
            controller: TextEditingController(
              text: initialValue.replaceAll('원', ''), // "원" 제거
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력 가능
            decoration: const InputDecoration(
              hintText: '새로운 시급을 입력하세요',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          );
      // 수업 횟수
        case '수업 횟수':
          return TextField(
            controller: TextEditingController(
              text: initialValue.replaceAll('회', ''), // 초기값 설정
            ),
            keyboardType: TextInputType.number, // 숫자 입력 전용 키보드
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력 가능
            decoration: const InputDecoration(
              hintText: '수업 횟수를 입력하세요',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (newValue) {
              controller.text = newValue; // 변경된 값을 controller에 저장
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
                                case '정산 방법':
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
