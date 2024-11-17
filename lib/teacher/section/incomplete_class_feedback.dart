import 'package:flutter/material.dart';
import 'package:studuler/teacher/widget/incomplete_class_feedback_tile.dart';

import '../../common/http/http_service.dart';

class IncompleteClassFeedback extends StatefulWidget {
  const IncompleteClassFeedback({
    super.key,
    required this.classId,
  });

  final String classId;

  @override
  State<IncompleteClassFeedback> createState() =>
      _IncompleteClassFeedbackState();
}

class _IncompleteClassFeedbackState extends State<IncompleteClassFeedback> {
  final HttpService httpService = HttpService();
  List<DateTime> incompleteFeedbackDates = [];

  @override
  void initState() {
    super.initState();

    () async {
      final result = await httpService.fetchIncompleteFeedbackDates(
        classId: widget.classId,
      );
      setState(() {
        incompleteFeedbackDates = result;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "미작성 피드백",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
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
