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

  final String classId;
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

  @override
  void initState() {
    super.initState();

    () async {
      await fetchIncompleteFeedbackDates();
    }();
  }

  Future<void> fetchIncompleteFeedbackDates() async {
    setState(() {
      isLoading = true;
    });

    // 테스트용 더미 데이터 생성
    await Future.delayed(const Duration(seconds: 1)); // 비동기 테스트
    final List<DateTime> result = List.generate(
      30, // 더미 데이터 수 (30개로 설정)
          (index) => DateTime.now().subtract(Duration(days: index)),
    );

    setState(() {
      isLoading = false;
      incompleteFeedbackDates = result;
    });
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
          Expanded(
            child: SingleChildScrollView( // 스크롤 가능하게 설정
              child: Column(
                children: List.generate(
                  incompleteFeedbackDates.length,
                      (index) => IncompleteClassFeedbackTile(
                    classId: widget.classId,
                    classTitle: widget.classTitle,
                    date: incompleteFeedbackDates.elementAt(index),
                    onPop: fetchIncompleteFeedbackDates,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
