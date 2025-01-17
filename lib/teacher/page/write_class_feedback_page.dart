import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../common/http/http_service.dart';
import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/auth_text_field.dart';
import '../../common/widget/background.dart';

class WriteClassFeedbackPage extends StatefulWidget {
  const WriteClassFeedbackPage({
    super.key,
    required this.classId,
    required this.classTitle,
    required this.date,
    required this.onPop,
  });

  final int classId;
  final String classTitle;
  final DateTime date;
  final Function onPop;

  @override
  State<WriteClassFeedbackPage> createState() => _WriteClassFeedbackPageState();
}

class _WriteClassFeedbackPageState extends State<WriteClassFeedbackPage> {
  final HttpService httpService = HttpService();

  final _didController = TextEditingController();
  final _attitudeController = TextEditingController();
  final ValueNotifier<String> _homework = ValueNotifier<String>("");
  final _memoController = TextEditingController();
  int _rating = 0;

  int buttonActivated = 0;
  String _dateToString() {
    String weekday = "";
    switch (widget.date.weekday) {
      case 1:
        weekday = "월요일";
        break;
      case 2:
        weekday = "화요일";
        break;
      case 3:
        weekday = "수요일";
        break;
      case 4:
        weekday = "목요일";
        break;
      case 5:
        weekday = "금요일";
        break;
      case 6:
        weekday = "토요일";
        break;
      case 7:
      default:
        weekday = "일요일";
        break;
    }
    return "${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일 $weekday";
  }

  @override
  void initState() {
    _didController.addListener(() {
      setState(() {});
    });
    _attitudeController.addListener(() {
      setState(() {});
    });
    _homework.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _didController.dispose();
    _attitudeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Widget cancelButton() {
    return GestureDectectorHidingKeyboard(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3).withOpacity(0.3),
        ),
        child: const Center(
          child: Text("취소"),
        ),
      ),
    );
  }

  Widget completeButton() {
    bool vaildationFail = (_didController.text.isEmpty &&
        _attitudeController.text.isEmpty &&
        _homework.value.isEmpty &&
        _rating == 0);
    return GestureDectectorHidingKeyboard(
      onTap: () async {
        if (vaildationFail) return;
        final feedbackId = await httpService.createClassFeedback(
          classId: widget.classId,
          date: widget.date,
          did: _didController.text,
          attitude: _attitudeController.text,
          homework: _homework.value,
          memo: _memoController.text,
          rating: _rating,
        );
        if (feedbackId != null) {
          if (context.mounted) {
            Navigator.pop(context);
            widget.onPop();
          }
        }
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: vaildationFail
              ? const Color(0xFFC7B7A3).withOpacity(0.3)
              : const Color(0xFFC7B7A3),
        ),
        child: Center(
          child: Text(
            "완료",
            style: TextStyle(
              color: vaildationFail ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(
      milliseconds: 100,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDectectorHidingKeyboard(
          child: Stack(
            children: [
              const Background(
                iconActionButtons: [],
              ),
              Column(
                children: [
                  const SizedBox(height: 120),
                  Text(
                    widget.classTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(64),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            _dateToString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                AuthTextField(
                                  controller: _didController,
                                  label: "오늘 한 일",
                                  hintText: "오늘 한 일을 적어주세요.",
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                AuthTextField(
                                  controller: _attitudeController,
                                  label: "태도",
                                  hintText: "태도를 적어주세요.",
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "숙제 완료 여부",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton.icon(
                                      style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.black87,
                                        ),
                                        overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                      ),
                                      onPressed: () {
                                        _homework.value = "완료";
                                        setState(() {
                                          buttonActivated = 1;
                                        });
                                      },
                                      icon: AnimatedContainer(
                                        duration: duration,
                                        curve: Curves.bounceInOut,
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: const Color(0xffffec9e),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: buttonActivated == 1
                                              ? const Color(0xffffec9e)
                                              : Colors.white70,
                                        ),
                                      ),
                                      label: const Text("완료"),
                                    ),
                                    TextButton.icon(
                                      style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.black87,
                                        ),
                                        overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                      ),
                                      onPressed: () {
                                        _homework.value = "부분완료";
                                        setState(() {
                                          buttonActivated = 2;
                                        });
                                      },
                                      icon: AnimatedContainer(
                                        duration: duration,
                                        curve: Curves.bounceInOut,
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: const Color(0xffffec9e),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: buttonActivated == 2
                                              ? const Color(0xffffec9e)
                                              : Colors.white70,
                                        ),
                                      ),
                                      label: const Text("부분완료"),
                                    ),
                                    TextButton.icon(
                                      style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.black87,
                                        ),
                                        overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent,
                                        ),
                                      ),
                                      onPressed: () {
                                        _homework.value = "미완료";
                                        setState(() {
                                          buttonActivated = 3;
                                        });
                                      },
                                      icon: AnimatedContainer(
                                        duration: duration,
                                        curve: Curves.bounceInOut,
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: const Color(0xffffec9e),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: buttonActivated == 3
                                              ? const Color(0xffffec9e)
                                              : Colors.white70,
                                        ),
                                      ),
                                      label: const Text("미완료"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                AuthTextField(
                                  controller: _memoController,
                                  label: "메모",
                                  hintText: "메모를 적어주세요.",
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "수업 점수",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                RatingBar.builder(
                                  initialRating: _rating.toDouble(),
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 10,
                                  itemSize: 32,
                                  unratedColor:
                                      const Color(0xFFC7B7A3).withOpacity(0.3),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Color(0xffc7b7a3),
                                  ),
                                  onRatingUpdate: (rating) {
                                    _rating = rating.toInt();
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    cancelButton(),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    completeButton(),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
