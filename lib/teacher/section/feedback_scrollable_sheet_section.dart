import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/model/class_day.dart';
import '../../common/model/class_feedback.dart';
import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/auth_text_field.dart';

class FeedbackScrollableSheetSection extends StatefulWidget {
  const FeedbackScrollableSheetSection({
    super.key,
    required this.isTeacher,
    required this.classId,
    required this.bottomSheetController,
    required this.maxBottomSheetFractionalValue,
    required this.selectedDate,
    required this.classFeedback,
    required this.classDay,
  });

  final bool isTeacher;
  final int classId;
  final ValueNotifier<Jiffy> selectedDate;
  final ValueNotifier<ClassFeedback?> classFeedback;
  final DraggableScrollableController bottomSheetController;
  final double maxBottomSheetFractionalValue;
  final List<ClassDay> classDay;

  @override
  State<FeedbackScrollableSheetSection> createState() =>
      _FeedbackScrollableSheetSectionState();
}

class _FeedbackScrollableSheetSectionState
    extends State<FeedbackScrollableSheetSection> {
  final sidePadding = const EdgeInsets.symmetric(horizontal: 12);
  final httpService = HttpService();

  final welldoneController = TextEditingController();
  final attitudeController = TextEditingController();
  final ValueNotifier<String> homework = ValueNotifier<String>("");
  final memoController = TextEditingController();
  int rating = 0;

  String _dateToString(DateTime date) {
    String weekday = "";
    switch (date.weekday) {
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
    return "${date.year}년 ${date.month}월 ${date.day}일 $weekday";
  }

  @override
  void initState() {
    widget.classFeedback.addListener(() {
      welldoneController.text = widget.classFeedback.value?.workdone ?? "";
      attitudeController.text = widget.classFeedback.value?.attitude ?? "";
      homework.value = _homeworkMapper(widget.classFeedback.value?.homework);
      memoController.text = widget.classFeedback.value?.memo ?? "";
      rating = widget.classFeedback.value?.rate ?? 5;
    });

    welldoneController.addListener(() {
      setState(() {});
    });
    attitudeController.addListener(() {
      setState(() {});
    });
    homework.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String _homeworkMapper(int? homework) {
    switch (homework) {
      case 0:
        return "미완료";
      case 1:
        return "부분완료";
      case 2:
        return "완료";
      default:
        return "";
    }
  }

  Widget cancelButton() {
    return GestureDectectorHidingKeyboard(
      onTap: () {
        welldoneController.text = "";
        attitudeController.text = "";
        homework.value = "";
        memoController.text = "";
        rating = widget.classFeedback.value?.rate ?? 0;
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3).withOpacity(0.3),
        ),
        child: const Center(
          child: Text(
            "취소",
          ),
        ),
      ),
    );
  }

  Widget completeButton(BuildContext context) {
    bool vaildationFail = (welldoneController.text.isEmpty &&
        attitudeController.text.isEmpty &&
        homework.value.isEmpty &&
        rating == 0);
    return GestureDectectorHidingKeyboard(
      onTap: () async {
        if (vaildationFail) return;
        if (widget.classFeedback.value == null) {
          final feedbackId = await httpService.createClassFeedback(
            classId: widget.classId,
            date: widget.selectedDate.value.dateTime,
            did: welldoneController.text,
            attitude: attitudeController.text,
            homework: homework.value,
            memo: memoController.text,
            rating: rating,
          );
          if (feedbackId != null) {
            widget.classFeedback.value = await httpService.fetchClassFeedback(
              classId: widget.classId,
              date: widget.selectedDate.value,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Durations.medium2,
                  content: Text("피드백 작성이 완료되었습니다."),
                ),
              );
            }
          }
        } else {
          final feedbackId = await httpService.updateClassFeedback(
            feedbackId: widget.classFeedback.value?.feedbackId ?? 0,
            did: welldoneController.text,
            attitude: attitudeController.text,
            homework: homework.value,
            memo: memoController.text,
            rating: rating,
          );
          if (feedbackId != null) {
            widget.classFeedback.value = await httpService.fetchClassFeedback(
              classId: widget.classId,
              date: widget.selectedDate.value,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Durations.medium2,
                  content: Text("피드백 수정이 완료되었습니다."),
                ),
              );
            }
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
            widget.classFeedback.value == null ? "완료" : "변경",
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
    return DraggableScrollableSheet(
      controller: widget.bottomSheetController,
      initialChildSize: 0,
      minChildSize: 0,
      maxChildSize: widget.maxBottomSheetFractionalValue,
      snap: true,
      snapSizes: [widget.maxBottomSheetFractionalValue],
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: ValueListenableBuilder(
            valueListenable: widget.classFeedback,
            builder: (
              BuildContext context,
              ClassFeedback? feedback,
              Widget? child,
            ) {
              bool isClassDay = false;
              for (ClassDay element in widget.classDay) {
                if (element.day
                    .isSame(widget.selectedDate.value, unit: Unit.day)) {
                  isClassDay = true;
                  break;
                }
              }
              if (isClassDay == false) {
                return Padding(
                  padding: sidePadding,
                  child: const Column(
                    children: [
                      Divider(),
                      Gap(200),
                      Text("수업이 없는 날이에요."),
                      Gap(200),
                    ],
                  ),
                );
              }
              if (widget.isTeacher == false && feedback == null) {
                return Padding(
                  padding: sidePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      const Gap(8),
                      Text(
                        _dateToString(
                          feedback?.date ?? widget.selectedDate.value.dateTime,
                        ),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      const Gap(28),
                      const Gap(150),
                      const Center(child: Text("선생님이 아직 피드백을 적지 않았어요")),
                      const Gap(200),
                    ],
                  ),
                );
              }
              final readOnly = !widget.isTeacher;
              final showCursor = !readOnly;
              return Container(
                height: MediaQuery.sizeOf(context).height * 0.9,
                color: Colors.white,
                child: Padding(
                  padding: sidePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Gap(8),
                      Text(
                        _dateToString(
                          feedback?.date ?? widget.selectedDate.value.dateTime,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const Gap(28),
                      AuthTextField(
                        controller: welldoneController,
                        label: "오늘 한 일",
                        hintText: "오늘 한 일을 적어주세요.",
                        readOnly: readOnly,
                        showCursor: showCursor,
                      ),
                      const Gap(16),
                      AuthTextField(
                        controller: attitudeController,
                        label: "태도",
                        hintText: "태도를 적어주세요.",
                        readOnly: readOnly,
                        showCursor: showCursor,
                      ),
                      const Gap(16),
                      Text(
                        "숙제 완료 여부",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              if (readOnly) return;
                              setState(() {
                                homework.value = "완료";
                              });
                            },
                            style: const ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black87,
                              ),
                              overlayColor: WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                            ),
                            icon: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: const Color(0xffffec9e),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: homework.value == "완료"
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("완료"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (readOnly) return;
                              setState(() {
                                homework.value = "부분완료";
                              });
                            },
                            style: const ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black87,
                              ),
                              overlayColor: WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                            ),
                            icon: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: const Color(0xffffec9e),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: homework.value == "부분완료"
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("부분완료"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (readOnly) return;
                              setState(() {
                                homework.value = "미완료";
                              });
                            },
                            style: const ButtonStyle(
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black87,
                              ),
                              overlayColor: WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                            ),
                            icon: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: const Color(0xffffec9e),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: homework.value == "미완료"
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("미완료"),
                          ),
                        ],
                      ),
                      const Gap(8),
                      AuthTextField(
                        controller: memoController,
                        label: "메모",
                        hintText: "메모를 적어주세요.",
                        readOnly: readOnly,
                        showCursor: showCursor,
                      ),
                      const Gap(16),
                      Text(
                        "수업 점수",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          RatingBar.builder(
                            ignoreGestures: readOnly,
                            initialRating: rating.toDouble(),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 10,
                            itemSize: 30,
                            unratedColor: const Color(0xFFC7B7A3).withOpacity(0.3),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Color(0xffc7b7a3),
                            ),
                            onRatingUpdate: (newRating) {
                              if (readOnly) return;
                              rating = newRating.toInt();
                              setState(() {});
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                      const Gap(16),
                      if (widget.isTeacher)
                        Row(
                          children: [
                            const Spacer(),
                            cancelButton(),
                            const SizedBox(
                              width: 16,
                            ),
                            completeButton(context),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      if (widget.isTeacher) const Gap(16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
