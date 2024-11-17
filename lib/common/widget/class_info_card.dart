import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../teacher/section/incomplete_class_feedback.dart';
import '../section/class_info_item.dart';
import '../section/animated_wave_painter.dart';
import 'edit_class_info_modal.dart';

class ClassInfoCard extends StatefulWidget {
  final String title;
  final String code;
  final int currentIndex;
  final int totalCards;
  final List<ClassInfoItem> infoItems;
  final double completionRate;
  final Color themeColor; // 테마 색상 추가
  final Function(
    String title,
    List<ClassInfoItem> infoItems,
    Color themeColor,
  ) onUpdate;

  const ClassInfoCard({
    required this.title,
    required this.code,
    required this.currentIndex,
    required this.totalCards,
    required this.infoItems,
    required this.completionRate,
    required this.themeColor, // 초기 테마 색상
    required this.onUpdate,
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
  late Color currentThemeColor; // 현재 테마 색상

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
    currentThemeColor = widget.themeColor; // 초기 테마 색상 설정
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EditClassInfoModal(
          titleController: titleController,
          studentNameController: studentNameController,
          sessionDurationController: sessionDurationController,
          daysController: daysController,
          paymentMethodController: paymentMethodController,
          hourlyRateController: hourlyRateController,
          sessionCountController: sessionCountController,
          nextPaymentDate: nextPaymentDate,
          themeColor: currentThemeColor, // 현재 테마 색상 전달
          onUpdate: (title, infoItems, themeColor) {
            setState(() {
              currentThemeColor = themeColor; // 테마 색상 업데이트
              widget.onUpdate(title, infoItems, themeColor);
            });
          },
        );
      },
    );
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("수업 코드가 클립보드에 복사되었습니다.")),
    );
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
                              onTap: () {},
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
                    Text(
                      titleController.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                      IncompleteClassFeedback(
                        classTitle: widget.title,
                        classId: 'dummyClassId',
                        backToClassInfo: () {
                          setState(() {
                            showIncompleteFeedbackList = false;
                          });
                        }, 
                      ),
                    if (!showIncompleteFeedbackList)
                      Column(
                        children: widget.infoItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: item,
                          );
                        }).toList(),
                      ),
                    if (!showIncompleteFeedbackList) const SizedBox(height: 16),
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
                            borderRadius:
                                BorderRadius.circular(10), // 버튼 모서리 둥글게
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
        Positioned(
          top: 0,
          child: ClipOval(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.transparent, // 원의 배경을 투명하게 설정
                border: Border.all(
                  color: currentThemeColor.withOpacity(0.2), // 테두리에 투명도 적용
                  width: 1,
                ), // 테두리 추가
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
                          waveColor: currentThemeColor, // 물결 애니메이션에 테마 색상 적용
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
      ],
    );
  }
}
