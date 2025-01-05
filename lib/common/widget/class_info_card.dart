import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/get_color_by_index.dart';
import 'edit_item_dialog.dart';
import '../../teacher/section/incomplete_class_feedback.dart';
import '../http/http_service.dart';
import '../section/class_info_item.dart';
import '../section/animated_wave_painter.dart';

class ClassInfoCard extends StatefulWidget {
  final String title;
  final String code;
  final int classId;
  final int currentIndex;
  final int totalCards;
  final List<ClassInfoItem> infoItems;
  final double completionRate;
  final Color themeColor;
  final Function(
      String title,
      List<ClassInfoItem> infoItems,
      Color themeColor,
      ) onUpdate;
  final Function(int, String, int) goToPerClassPage;
  final Function(int classId) onDelete;

  const ClassInfoCard({
    required this.title,
    required this.code,
    required this.classId,
    required this.currentIndex,
    required this.totalCards,
    required this.infoItems,
    required this.completionRate,
    required this.themeColor,
    required this.onUpdate,
    required this.goToPerClassPage,
    required this.onDelete,
    super.key,
  });

  @override
  State<ClassInfoCard> createState() => _ClassInfoCardState();
}

class _ClassInfoCardState extends State<ClassInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TextEditingController titleController;
  late TextEditingController studentNameController;
  late TextEditingController sessionDurationController;
  late TextEditingController daysController;
  late TextEditingController paymentMethodController;
  late TextEditingController hourlyRateController;
  late TextEditingController sessionCountController;
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
    studentNameController =
        TextEditingController(text: widget.infoItems[0].value);
    sessionDurationController =
        TextEditingController(text: widget.infoItems[1].value);
    daysController = TextEditingController(text: widget.infoItems[2].value);
    paymentMethodController =
        TextEditingController(text: widget.infoItems[3].value);
    hourlyRateController =
        TextEditingController(text: widget.infoItems[4].value);
    sessionCountController =
        TextEditingController(text: widget.infoItems[5].value);
    nextPaymentDate =
    widget.infoItems.length > 6 ? widget.infoItems[6].value : '';
    currentThemeColor = widget.themeColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    studentNameController.dispose();
    sessionDurationController.dispose();
    daysController.dispose();
    paymentMethodController.dispose();
    hourlyRateController.dispose();
    sessionCountController.dispose();
    super.dispose();
  }

  void _editClassInfo() {
    final Map<String, dynamic> classData = {
      'name': '링가링',
      'classid': widget.classId,
      'classcode': widget.code,
      'classname': widget.title,
      'day': widget.infoItems[2].value,
      'time': widget.infoItems[1].value,
      'period': widget.infoItems[5].value,
      'dateofpayment': nextPaymentDate,
      'hourlyrate': widget.infoItems[4].value,
      'prepay': '1',
      'themecolor': widget.themeColor.value,
      'finished_lessons': '0',
    };

    EditItemDialog.showSelectItemDialog(
      context: context,
      classData: classData,
      items: [
        {
          'title': '학생 이름',
          'controller': studentNameController,
          'onUpdate': (String newValue) {
            setState(() {
              studentNameController.text = newValue;
            });
          },
        },
        {
          'title': '회당 시간',
          'controller': sessionDurationController,
          'onUpdate': (String newValue) {
            setState(() {
              sessionDurationController.text = newValue;
            });
          },
        },
        {
          'title': '요일',
          'controller': daysController,
          'onUpdate': (String newValue) {
            setState(() {
              daysController.text = newValue;
            });
          },
        },
        {
          'title': '정산 방법',
          'controller': paymentMethodController,
          'onUpdate': (String newValue) {
            setState(() {
              paymentMethodController.text = newValue;
            });
          },
        },
        {
          'title': '시급',
          'controller': hourlyRateController,
          'onUpdate': (String newValue) {
            setState(() {
              hourlyRateController.text = newValue;
            });
          },
        },
        {
          'title': '수업 횟수',
          'controller': sessionCountController,
          'onUpdate': (String newValue) {
            setState(() {
              sessionCountController.text = newValue;
            });
          },
        },
      ],
    );
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("수업 코드가 클립보드에 복사되었습니다.")),
    );
  }

  void _deleteClass() async {
    try {
      final confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("수업 삭제"),
          content: const Text("정말로 이 수업을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("삭제"),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final success = await HttpService().deleteClass(widget.classId);

        if (success) {
          widget.onDelete(widget.classId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("수업이 삭제되었습니다.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("수업 삭제에 실패했습니다.")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("알 수 없는 오류가 발생했습니다.")),
      );
    }
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
                                onTap: () {},
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _editClassInfo,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _deleteClass,
                                child: const Icon(
                                  Icons.delete,
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
                            widget.code,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: _copyCodeToClipboard,
                            child: const Icon(
                              Icons.copy,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: widget.infoItems.map((item) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width * 0.9 -
                                    48) /
                                    2,
                                height: MediaQuery.of(context).size.height *
                                    0.08,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 26.0),
                                    child: item,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      if (!showIncompleteFeedbackList)
                        const SizedBox(height: 16),
                      if (!showIncompleteFeedbackList)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showIncompleteFeedbackList = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC7B7A3),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('미작성 피드백 바로가기'),
                        ),
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
                      '${(widget.completionRate * 100).toInt()}%',
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
