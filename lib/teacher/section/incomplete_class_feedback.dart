import 'package:flutter/material.dart';
import 'package:studuler/teacher/widget/incomplete_class_feedback_tile.dart';

import '../../common/http/http_service.dart';

class IncompleteClassFeedback extends StatefulWidget {
  const IncompleteClassFeedback({
    super.key,
    required this.classId,
    required this.backToClassInfo,
  });

  final String classId;
  final VoidCallback backToClassInfo;

  @override
  State<IncompleteClassFeedback> createState() =>
      _IncompleteClassFeedbackState();
}

class _IncompleteClassFeedbackState extends State<IncompleteClassFeedback> {
  final HttpService httpService = HttpService();
  List<DateTime> incompleteFeedbackDates = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    () async {
      setState(() {
        isLoading = true;
      });
      final result = await httpService.fetchIncompleteFeedbackDates(
        classId: widget.classId,
      );
      setState(() {
        isLoading = false;
        incompleteFeedbackDates = result;
      });
    }();
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
        if (!isLoading)
          Column(
            children: List.generate(
              incompleteFeedbackDates.length,
              (index) => IncompleteClassFeedbackTile(
                classId: widget.classId,
                date: incompleteFeedbackDates.elementAt(index),
              ),
            ),
          ),
      ],
    );
  }
}
