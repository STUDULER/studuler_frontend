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
    required this.classId,
    required this.bottomSheetController,
    required this.maxBottomSheetFractionalValue,
    required this.selectedDate,
    required this.classFeedback,
    required this.classDay,
  });

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
  String homework = "";
  final memoController = TextEditingController();
  int rating = 5;

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
      homework = widget.classFeedback.value?.homework.toString() ?? "";
      memoController.text = widget.classFeedback.value?.memo ?? "";
      rating = widget.classFeedback.value?.rate ?? 5;
    });
    super.initState();
  }

  Widget cancelButton() {
    return GestureDectectorHidingKeyboard(
      onTap: () {
        welldoneController.text = "";
        attitudeController.text = "";
        homework = "";
        memoController.text = "";
        rating = widget.classFeedback.value?.rate ?? 5;
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

  Widget completeButton() {
    return GestureDectectorHidingKeyboard(
      onTap: () async {
        if (welldoneController.text.isEmpty) return;
        if (attitudeController.text.isEmpty) return;
        if (homework.isEmpty) return;
        if (memoController.text.isEmpty) return;

        final feedbackId = await httpService.createClassFeedback(
          classId: widget.classId,
          date: widget.selectedDate.value.dateTime,
          did: welldoneController.text,
          attitude: attitudeController.text,
          homework: homework,
          memo: memoController.text,
          rating: rating,
        );
        if (feedbackId != null) {
          widget.classFeedback.value = await httpService.fetchClassFeedback(
            date: widget.selectedDate.value,
          );
        }
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text(
            "완료",
            style: TextStyle(
              color: Colors.white,
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
              final readOnly = feedback != null;
              final showCursor = !readOnly;
              return Container(
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
                            color: Colors.grey),
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
                                homework = "0";
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
                                color: homework == "0"
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
                                homework = "1";
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
                                color: homework == "1"
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
                                homework = "2";
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
                                color: homework == "2"
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
                      RatingBar.builder(
                        ignoreGestures: readOnly,
                        initialRating: rating.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 10,
                        itemSize: 32,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          if (readOnly) return;
                          rating = newRating.toInt();
                        },
                      ),
                      const Gap(16),
                      if (!readOnly)
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
                        ),
                      if (!readOnly) const Gap(16),
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
