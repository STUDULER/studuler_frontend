/*
import 'package:flutter/material.dart';
import '../section/class_info_item.dart';

class EditClassInfoModal extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController studentNameController;
  final TextEditingController sessionDurationController;
  final TextEditingController daysController;
  final TextEditingController paymentMethodController;
  final TextEditingController hourlyRateController;
  final TextEditingController sessionCountController;
  final String nextPaymentDate;
  final Color themeColor;
  final void Function(String title, List<ClassInfoItem> infoItems, Color themeColor) onUpdate;

  const EditClassInfoModal({
    required this.titleController,
    required this.studentNameController,
    required this.sessionDurationController,
    required this.daysController,
    required this.paymentMethodController,
    required this.hourlyRateController,
    required this.sessionCountController,
    required this.nextPaymentDate,
    required this.themeColor,
    required this.onUpdate,
    super.key,
  });

  @override
  _EditClassInfoModalState createState() => _EditClassInfoModalState();
}

class _EditClassInfoModalState extends State<EditClassInfoModal> {
  late TextEditingController _hourlyRateController;
  late Color selectedColor;
  final List<String> selectedDays = [];
  final List<String> sessionDurationOptions = ['1', '2', '3', '4', '5', '6'];
  final List<String> sessionCountOptions = ['4', '8', '12', '16'];

  final Map<String, int> dayOrder = {
    '월': 1,
    '화': 2,
    '수': 3,
    '목': 4,
    '금': 5,
    '토': 6,
    '일': 7,
  };

  final Color selectedBoxColor = const Color(0xFFC7B7A3);
  final Color unselectedBoxColor = const Color(0x4DC7B7A3);
  final Color selectedTextColor = Colors.white;
  final Color unselectedTextColor = const Color(0xFFC7B7A3);

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

  @override
  void initState() {
    super.initState();

    _hourlyRateController = TextEditingController(text: widget.hourlyRateController.text.replaceAll('원', ''));
    selectedColor = widget.themeColor;

    _hourlyRateController.addListener(() {
      final input = _hourlyRateController.text.replaceAll(RegExp(r'\D'), '');
      _hourlyRateController.value = TextEditingValue(
        text: input.isNotEmpty ? '$input원' : '',
        selection: TextSelection.collapsed(offset: input.length),
      );
    });

    selectedDays.addAll(widget.daysController.text.split('/').where((day) => day.isNotEmpty));
  }

  String getSortedDaysString() {
    selectedDays.sort((a, b) => dayOrder[a]!.compareTo(dayOrder[b]!));
    return selectedDays.join('/');
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // paymentMethodController의 초기값 출력
    print('Initial payment method: ${widget.paymentMethodController.text}');
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ㅡ 모양 아이콘 추가
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4), // 모서리를 둥글게 설정
                  ),
                ),
                const SizedBox(height: 16), // 아이콘과 텍스트 사이 간격 조정
                Text(
                  '수업 이름',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: widget.titleController,
                    textAlign: TextAlign.left, // 왼쪽 정렬
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '학생 이름',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: widget.studentNameController,
                    textAlign: TextAlign.left, // 왼쪽 정렬
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '회당 시간',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DropdownButtonFormField<String>(
                    value: sessionDurationOptions.contains(widget.sessionDurationController.text.replaceAll('시간', ''))
                        ? widget.sessionDurationController.text.replaceAll('시간', '')
                        : sessionDurationOptions[0], // 기본값 설정
                    items: sessionDurationOptions.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('$value 시간'),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.sessionDurationController.text = '$newValue 시간';
                      });
                    },
                  )
                ),
                const SizedBox(height: 16),
                Text(
                  '정산 방법',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      int selectedMethod = widget.paymentMethodController.text == '후불' ? 0 : 1; // 초기값 설정
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMethod = 1;
                                widget.paymentMethodController.text = '선불';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: selectedMethod == 1 ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '선불',
                                style: TextStyle(
                                  color: selectedMethod == 1 ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMethod = 0;
                                widget.paymentMethodController.text = '후불';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: selectedMethod == 0 ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '후불',
                                style: TextStyle(
                                  color: selectedMethod == 0 ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '시급',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _hourlyRateController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.left, // 왼쪽 정렬
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '수업 횟수',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: DropdownButtonFormField<String>(
                    isDense: true,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                    ),
                    value: sessionCountOptions.contains(widget.sessionCountController.text) ? widget.sessionCountController.text : sessionCountOptions[0],
                    items: sessionCountOptions.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Align(
                          alignment: Alignment.centerLeft, // 왼쪽 정렬
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.sessionCountController.text = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '테마 색상 선택',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: themeColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 15,
                        child: selectedColor == color ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onUpdate(
                      widget.titleController.text,
                      [
                        ClassInfoItem(icon: Icons.person, title: '학생 이름', value: widget.studentNameController.text),
                        ClassInfoItem(icon: Icons.access_time, title: '회당 시간', value: widget.sessionDurationController.text),
                        ClassInfoItem(icon: Icons.calendar_today, title: '요일', value: getSortedDaysString()),
                        ClassInfoItem(icon: Icons.payment, title: '정산 방법', value: widget.paymentMethodController.text),
                        ClassInfoItem(icon: Icons.attach_money, title: '시급', value: _hourlyRateController.text),
                        ClassInfoItem(icon: Icons.repeat, title: '수업 횟수', value: widget.sessionCountController.text),
                        ClassInfoItem(icon: Icons.calendar_today, title: '이번 회차 정산일', value: widget.nextPaymentDate),
                      ],
                      selectedColor,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedBoxColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('수정 내용 저장'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/