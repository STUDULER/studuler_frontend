import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../common/util/get_color_by_index.dart';
import 'edit_item_dialog_student.dart';
import '../../teacher/section/incomplete_class_feedback.dart';
import '../../common/http/http_service.dart';
import '../../common/section/class_info_item.dart';
import '../../common/section/animated_wave_painter.dart';

class ClassInfoCardStudent extends StatefulWidget {
  final String title;
  final String code;
  final int classId;
  final int currentIndex;
  final int totalCards;
  final List<ClassInfoItem> infoItems;
  final double completionRate;
  final int finishedLessons;
  final int period;
  final Color themeColor;
  final Function(
      String title,
      List<ClassInfoItem> infoItems,
      Color themeColor,
      ) onUpdate;
  final Function(int, String, int) goToPerClassPage;

  const ClassInfoCardStudent({
    required this.title,
    required this.code,
    required this.classId,
    required this.currentIndex,
    required this.totalCards,
    required this.infoItems,
    required this.completionRate,
    required this.finishedLessons,
    required this.period,
    required this.themeColor,
    required this.onUpdate,
    required this.goToPerClassPage,
    super.key,
  });

  @override
  State<ClassInfoCardStudent> createState() => _ClassInfoCardStudentState();
}

class _ClassInfoCardStudentState extends State<ClassInfoCardStudent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController titleController;
  late TextEditingController teacherNameController;
  late TextEditingController sessionDurationController;
  late TextEditingController daysController;
  late TextEditingController paymentMethodController;
  late TextEditingController hourlyRateController;
  late TextEditingController sessionCountController;
  late TextEditingController themeColorController;
  late String nextPaymentDate;
  late Color currentThemeColor;

  bool showIncompleteFeedbackList = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    titleController = TextEditingController(text: widget.title);
    teacherNameController =
        TextEditingController(text: widget.infoItems[0].value);
    sessionDurationController =
        TextEditingController(text: widget.infoItems[1].value.replaceAll('시간', ''));
    daysController = TextEditingController(text: widget.infoItems[2].value);
    paymentMethodController =
        TextEditingController(text: widget.infoItems[3].value);
    hourlyRateController =
        TextEditingController(text: widget.infoItems[4].value.replaceAll('원', ''));
    sessionCountController =
        TextEditingController(text: widget.infoItems[5].value.replaceAll('회', ''));
    nextPaymentDate =
    widget.infoItems.length > 6 ? widget.infoItems[6].value : '';
    currentThemeColor = widget.themeColor;

    themeColorController = TextEditingController(
      text: widget.themeColor.value.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    teacherNameController.dispose();
    sessionDurationController.dispose();
    daysController.dispose();
    paymentMethodController.dispose();
    hourlyRateController.dispose();
    sessionCountController.dispose();
    themeColorController.dispose();
    super.dispose();
  }

  void _editClassInfo() {
    EditItemDialogStudent.showSelectItemDialog(
      context: context,
      classData: {'classid': widget.classId},
      items: [
        {
          'title': '선생님 이름',
          'controller': teacherNameController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateTeacherNameS(
              classId: widget.classId,
              teacherName: newValue,
            );
            if (success) {
              setState(() {
                teacherNameController.text = newValue;
              });
              widget.onUpdate(
                titleController.text,
                _getUpdatedInfoItems(),
                currentThemeColor,
              );
            }
          },
        },
        {
          'title': '수업 이름',
          'controller': titleController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateClassNameS(
              classId: widget.classId,
              className: newValue,
            );
            if (success) {
              setState(() {
                titleController.text = newValue;
              });
              widget.onUpdate(
                newValue,
                _getUpdatedInfoItems(),
                currentThemeColor,
              );
            }
          },
        },
        {
          'title': '테마 색상',
          'controller': themeColorController,
          'onUpdate': (String newValue) async {
            final int colorValue = int.parse(newValue);
            final success = await HttpService().updateThemeColorS(
              classId: widget.classId,
              themeColor: int.parse(newValue),
            );
            if (success) {
              setState(() {
                themeColorController.text = newValue;
                currentThemeColor = getColorByIndex(int.parse(newValue));
                // print("현재 색상: $currentThemeColor ");
              });
              widget.onUpdate(
                titleController.text,
                _getUpdatedInfoItems(),
                currentThemeColor,
              );
            }
          },
        },
      ],
    );
  }

  List<ClassInfoItem> _getUpdatedInfoItems() {
    return [
      ClassInfoItem(
        icon: Icons.person,
        title: '선생님 이름',
        value: teacherNameController.text,
      ),
      ClassInfoItem(
        icon: Icons.access_time,
        title: '회당 시간',
        value: '${sessionDurationController.text}시간',
      ),
      ClassInfoItem(
        icon: Icons.calendar_today,
        title: '요일',
        value: daysController.text,
      ),
      ClassInfoItem(
        icon: Icons.payment,
        title: '정산 방법',
        value: paymentMethodController.text,
      ),
      ClassInfoItem(
        icon: Icons.attach_money,
        title: '시급',
        value: '${hourlyRateController.text}원',
      ),
      ClassInfoItem(
        icon: Icons.repeat,
        title: '수업 횟수',
        value: '${sessionCountController.text}회',
      ),
      ClassInfoItem(
        icon: Icons.calendar_today,
        title: '이번 회차 정산일',
        value: nextPaymentDate.isNotEmpty
            ? nextPaymentDate
            : '정보 없음', // 정산일이 없을 경우 대체값 표시
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 32,
          child: ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.currentIndex + 1} / ${widget.totalCards}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _editClassInfo,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          widget.goToPerClassPage(
                            widget.classId,
                            titleController.text,
                            getIndexByColor(currentThemeColor),
                          );
                        },
                        child: Text(
                          titleController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '',   // 학생은 수업 코드 복사 필요 없음
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                      const Divider(),
                      if (showIncompleteFeedbackList)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.475,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IncompleteClassFeedback(
                              classTitle: widget.title,
                              classId: widget.classId,
                              backToClassInfo: () {
                                setState(() {
                                  showIncompleteFeedbackList = false;
                                });
                              },
                            ),
                          ),
                        ),
                      if (!showIncompleteFeedbackList)
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02, // 시작 위치를 아래로 내림
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Wrap(
                                spacing: 16.0,
                                runSpacing: 16.0,
                                children: widget.infoItems.map((item) {
                                  return SizedBox(
                                    width: (MediaQuery.of(context).size.width * 0.9 - 48) / 2,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0.0),
                                        child: item,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      if (!showIncompleteFeedbackList)
                        const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.goToPerClassPage(
              widget.classId,
              titleController.text,
              getIndexByColor(currentThemeColor),
            );
          },
          child: Positioned(
            top: 0,
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: currentThemeColor.withOpacity(0.2),
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(100, 100),
                          painter: AnimatedWavePainter(
                            progress: widget.completionRate,
                            animation: _controller,
                            waveColor: currentThemeColor,
                          ),
                        );
                      },
                    ),
                    Text(
                      '${widget.finishedLessons} / ${widget.period}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
