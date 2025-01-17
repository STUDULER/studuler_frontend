import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
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
  final int finishedLessons;
  final int period;
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
    required this.finishedLessons,
    required this.period,
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
    studentNameController =
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
    studentNameController.dispose();
    sessionDurationController.dispose();
    daysController.dispose();
    paymentMethodController.dispose();
    hourlyRateController.dispose();
    sessionCountController.dispose();
    themeColorController.dispose();
    super.dispose();
  }

  void _editClassInfo() {
    EditItemDialog.showSelectItemDialog(
      context: context,
      classData: {'classid': widget.classId},
      items: [
        {
          'title': '학생 이름',
          'controller': studentNameController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateStudentName(
              classId: widget.classId,
              studentName: newValue,
            );
            if (success) {
              setState(() {
                studentNameController.text = newValue;
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
            final success = await HttpService().updateClassName(
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
          'title': '요일',
          'controller': daysController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateDay(
              classId: widget.classId,
              day: newValue,
            );
            if (success) {
              setState(() {
                daysController.text = newValue;
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
          'title': '회당 시간',
          'controller': sessionDurationController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateTime(
              classId: widget.classId,
              time: int.parse(newValue),
            );
            if (success) {
              setState(() {
                sessionDurationController.text = newValue;
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
          'title': '수업 횟수',
          'controller': sessionCountController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updatePeriod(
              classId: widget.classId,
              period: int.parse(newValue),
            );
            if (success) {
              setState(() {
                sessionCountController.text = newValue;
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
          'title': '시급',
          'controller': hourlyRateController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateHourlyRate(
              classId: widget.classId,
              hourlyRate: int.parse(newValue),
            );
            if (success) {
              setState(() {
                hourlyRateController.text = newValue;
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
          'title': '정산 방법',
          'controller': paymentMethodController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updatePrepay(
              classId: widget.classId,
              prepay: int.parse(newValue),
            );
            if (success) {
              setState(() {
                paymentMethodController.text = newValue;
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
          'title': '테마 색상',
          'controller': themeColorController,
          'onUpdate': (String newValue) async {
            final success = await HttpService().updateThemeColor(
              classId: widget.classId,
              themeColor: int.parse(newValue),
            );
            if (success) {
              setState(() {
                themeColorController.text = newValue;
                currentThemeColor = getColorByIndex(int.parse(newValue));
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
        title: '학생 이름',
        value: studentNameController.text,
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
        value: paymentMethodController.text == '1' ? '선불' : '후불',
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

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("수업 코드가 클립보드에 복사되었습니다.")),
    );
  }

  void _deleteClass() async {
    TextEditingController deleteController = TextEditingController();
    bool validationError = false;

    final confirmed = await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "수업을 삭제하시겠습니까?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "삭제 시 해당 수업의 정보가 모두 삭제됩니다.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "삭제를 원하실 경우 '삭제'를 입력해주세요.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: deleteController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorText: validationError ? "'삭제'를 입력해주세요." : null,
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            height: 1.5,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "'확인' 클릭 시 해당 동작은 되돌릴 수 없습니다.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 60,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFC7B7A3).withOpacity(0.34),
                                foregroundColor: const Color(0xFFC7B7A3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, false),
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
                              onPressed: () {
                                if (deleteController.text != "삭제") {
                                  setState(() {
                                    validationError = true;
                                  });
                                  return;
                                }
                                Navigator.pop(context, true);
                              },
                              child: const Text("확인"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (confirmed == true) {
      try {
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("알 수 없는 오류가 발생했습니다.")),
        );
      }
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
                                onTap: () async {
                                  if (await ShareClient.instance
                                      .isKakaoTalkSharingAvailable()) {
                                    try {
                                      final feedTemplate = FeedTemplate(
                                        content: Content(
                                          title: "[${widget.title}] 수업 코드 안내",
                                          description: "수업 코드: ${widget.code}\n앱에서 수업 코드를 입력하여 수업에 참여하세요.",
                                          imageUrl: Uri.parse('https://via.placeholder.com/300'), // 이미지 URL (선택)
                                          link: Link(
                                            webUrl: Uri.parse('https://developers.kakao.com'),
                                            mobileWebUrl: Uri.parse('https://developers.kakao.com'),
                                          ),
                                        ),
                                        buttons: [
                                          Button(
                                            title: "수업 추가하기",
                                            link: Link(
                                              webUrl: Uri.parse('https://developers.kakao.com'),
                                              mobileWebUrl: Uri.parse('https://developers.kakao.com'),
                                            ),
                                          ),
                                        ],
                                      );

                                      Uri uri = await ShareClient.instance
                                          .shareDefault(template: feedTemplate);
                                      await ShareClient.instance
                                          .launchKakaoTalk(uri);
                                      print('카카오톡 공유 완료');
                                    } catch (error) {
                                      print('카카오톡 공유 실패 $error');
                                    }
                                  }
                                },
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
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
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02, // 시작 위치를 아래로 내림
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.37,
                              child: Wrap(
                                spacing: 16.0,
                                runSpacing: 16.0,
                                children: widget.infoItems.map((item) {
                                  return SizedBox(
                                    width: (MediaQuery.of(context).size.width * 0.9 - 48) / 2,
                                    height: MediaQuery.of(context).size.height * 0.07,
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
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showIncompleteFeedbackList = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC7B7A3),
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, // 버튼 가로 크기 조정
                                  MediaQuery.of(context).size.height * 0.05, // 버튼 높이를 화면 비율로 설정
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('미작성 피드백 바로가기'),
                            ),
                          ],
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
