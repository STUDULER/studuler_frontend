import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/model/class_feedback.dart';
import '../../common/widget/auth_text_field.dart';

class FeedbackScrollableSheetSection extends StatefulWidget {
  const FeedbackScrollableSheetSection({
    super.key,
    required this.bottomSheetController,
    required this.maxBottomSheetFractionalValue,
    required this.selectedDate,
    required this.classFeedback,
  });

  final ValueNotifier<Jiffy> selectedDate;
  final ValueNotifier<ClassFeedback?> classFeedback;
  final DraggableScrollableController bottomSheetController;
  final double maxBottomSheetFractionalValue;

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
  final memoController = TextEditingController();

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
    super.initState();
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
              if (feedback == null) return const SizedBox.shrink();
              welldoneController.text = feedback.workdone;
              attitudeController.text = feedback.attitude;
              memoController.text = feedback.memo;
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
                        _dateToString(feedback.date),
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
                        readOnly: true,
                        showCursor: false,
                      ),
                      const Gap(16),
                      AuthTextField(
                        controller: attitudeController,
                        label: "태도",
                        hintText: "태도를 적어주세요.",
                        readOnly: true,
                        showCursor: false,
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
                            onPressed: () {},
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
                                color: feedback.homework == 0
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("부분완료"),
                          ),
                          TextButton.icon(
                            onPressed: () {},
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
                                color: feedback.homework == 1
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("부분완료"),
                          ),
                          TextButton.icon(
                            onPressed: () {},
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
                                color: feedback.homework == 2
                                    ? const Color(0xffffec9e)
                                    : Colors.white70,
                              ),
                            ),
                            label: const Text("부분완료"),
                          ),
                        ],
                      ),
                      const Gap(8),
                      AuthTextField(
                        controller: memoController,
                        label: "메모",
                        hintText: "메모를 적어주세요.",
                        readOnly: true,
                        showCursor: false,
                      ),
                      const Gap(16),
                      Text(
                        "수업 점수",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: feedback.rate.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 10,
                        itemSize: 32,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (_) {},
                      ),
                      const Gap(16),
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
