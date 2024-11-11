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

  final Color selectedBoxColor = const Color(0xFFC7B7A3); // 선택된 박스 색상
  final Color unselectedBoxColor = const Color(0x4DC7B7A3); // 선택되지 않은 박스 색상 (30% 투명도)
  final Color selectedTextColor = Colors.white; // 선택된 요일의 텍스트 색상
  final Color unselectedTextColor = const Color(0xFFC7B7A3); // 선택되지 않은 요일의 텍스트 색상

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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.titleController,
                decoration: const InputDecoration(labelText: '수업 제목'),
              ),
              TextField(
                controller: widget.studentNameController,
                decoration: const InputDecoration(labelText: '학생 이름'),
              ),
              DropdownButtonFormField<String>(
                value: sessionDurationOptions.contains(widget.sessionDurationController.text.replaceAll('시간', ''))
                    ? widget.sessionDurationController.text.replaceAll('시간', '')
                    : sessionDurationOptions[0],
                decoration: const InputDecoration(labelText: '회당 시간'),
                items: sessionDurationOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value 시간'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    widget.sessionDurationController.text = '$newValue 시간';
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('요일 수정', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: ['월', '화', '수', '목', '금', '토', '일']
                    .map(
                      (day) => ChoiceChip(
                    label: Text(
                      day,
                      style: TextStyle(
                        color: selectedDays.contains(day) ? selectedTextColor : unselectedTextColor,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        widget.daysController.text = getSortedDaysString();
                      });
                    },
                    showCheckmark: false,
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: ['선불', '후불'].contains(widget.paymentMethodController.text) ? widget.paymentMethodController.text : '선불',
                decoration: const InputDecoration(labelText: '정산 방법'),
                items: ['선불', '후불'].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    widget.paymentMethodController.text = newValue!;
                  });
                },
              ),
              TextField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(labelText: '시급'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: sessionCountOptions.contains(widget.sessionCountController.text) ? widget.sessionCountController.text : sessionCountOptions[0],
                decoration: const InputDecoration(labelText: '수업 횟수'),
                items: sessionCountOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    widget.sessionCountController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('테마 색상 선택', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Wrap(
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
              // 수정된 버튼 스타일
              ElevatedButton(
                onPressed: () {
                  widget.onUpdate(
                    widget.titleController.text,
                    [
                      ClassInfoItem(icon: Icons.person, title: '학생 이름', value: widget.studentNameController.text),
                      ClassInfoItem(icon: Icons.access_time, title: '회당 시간', value: '${widget.sessionDurationController.text}'),
                      ClassInfoItem(icon: Icons.calendar_today, title: '요일', value: getSortedDaysString()),
                      ClassInfoItem(icon: Icons.payment, title: '정산 방법', value: widget.paymentMethodController.text),
                      ClassInfoItem(icon: Icons.attach_money, title: '시급', value: _hourlyRateController.text),
                      ClassInfoItem(icon: Icons.repeat, title: '수업 횟수', value: widget.sessionCountController.text),
                      ClassInfoItem(icon: Icons.calendar_today, title: '다음 정산일', value: widget.nextPaymentDate),
                    ],
                    selectedColor,
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedBoxColor, // 버튼 색상 설정
                  foregroundColor: Colors.white, // 텍스트 색상 설정
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리를 둥글게 설정
                  ),
                ),
                child: const Text('수정 내용 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
