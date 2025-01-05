import 'package:flutter/material.dart';

import '../../common/http/http_service.dart';
import '../widget/incomplete_class_feedback_tile.dart';

class IncompleteClassFeedback extends StatefulWidget {
  const IncompleteClassFeedback({
    super.key,
    required this.classId,
    required this.classTitle,
    required this.backToClassInfo,
  });

  final int classId;
  final String classTitle;
  final VoidCallback backToClassInfo;

  @override
  State<IncompleteClassFeedback> createState() =>
      _IncompleteClassFeedbackState();
}

class _IncompleteClassFeedbackState extends State<IncompleteClassFeedback> {
  final HttpService httpService = HttpService();
  List<DateTime> incompleteFeedbackDates = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchIncompleteFeedbackDates();
  }

  Future<void> fetchIncompleteFeedbackDates() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      debugPrint(
          "widget.classId: ${widget.classId} (${widget.classId.runtimeType})");

      final List<DateTime> result =
      await httpService.fetchIncompleteFeedbackDates(
        classId: widget.classId,
      );

      setState(() {
        incompleteFeedbackDates = result;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      // 터미널에 오류 출력
      debugPrint("Error fetching incomplete feedback dates: $e");
      debugPrint("Stack Trace: $stackTrace");

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: widget.backToClassInfo,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
            const Spacer(),
            const Text(
              "미작성 피드백",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.transparent,
            ), // 레이아웃을 맞추기 위한 더미 아이콘
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        if (isLoading)
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black54,
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "오류 발생: $errorMessage",
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        if (!isLoading && errorMessage == null)
          if (incompleteFeedbackDates.isEmpty)
            Expanded(
              child: Column(
                children: [
                  const Spacer(flex: 4), // 위쪽 공간 비율
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "현재 미작성된 피드백이 없습니다.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(flex: 6), // 아래쪽 공간 비율
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: incompleteFeedbackDates.map((date) {
                    return IncompleteClassFeedbackTile(
                      classId: widget.classId,
                      classTitle: widget.classTitle,
                      date: date,
                      onPop: fetchIncompleteFeedbackDates,
                    );
                  }).toList(),
                ),
              ),
            ),
      ],
    );
  }
}
