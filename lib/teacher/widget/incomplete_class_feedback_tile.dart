import 'package:flutter/material.dart';

class IncompleteClassFeedbackTile extends StatelessWidget {
  const IncompleteClassFeedbackTile({
    super.key,
    required this.classId,
    required this.date,
  });

  final String classId;
  final DateTime date;

  GestureDetector goToWriteFeedbackButton() {
    return GestureDetector(
      onTap: () {
        print(date);
      },
      child: Container(
        width: 102,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("작성하기"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "${date.year}년 ${date.month}월 ${date.day}일",
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          goToWriteFeedbackButton(),
        ],
      ),
    );
  }
}
