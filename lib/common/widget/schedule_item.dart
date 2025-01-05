import 'package:flutter/material.dart';
import '../section/feedback_label.dart'; // FeedbackLabel 파일 import

class ScheduleItem extends StatelessWidget {
  final String title; // 일정 제목
  final String label; // 라벨 텍스트 (예: "피드백 완료", "피드백 미완료")
  final bool isFeedbackComplete; // 피드백 완료 여부
  final Color dotColor; // 수업 코드 색상

  const ScheduleItem({
    Key? key,
    required this.title,
    required this.label,
    required this.isFeedbackComplete,
    required this.dotColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 피드백 상태에 따른 색상 설정
    final backgroundColor = isFeedbackComplete ? const Color(0xFFFFEC9E) : const Color(0xFFC7B7A3);
    final textColor = Colors.black; // 글자 색상
    final feedbackDotColor = const Color(0xFFF1F1F1); // 피드백 상태 조그마한 원 색상

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5), // 테두리 추가
      ),
      child: Row(
        children: [
          // 왼쪽 컬러 점 (수업 코드 색상)
          CircleAvatar(
            backgroundColor: dotColor, // 수업 코드 색상
            radius: 10, // 크기 조정
          ),
          const SizedBox(width: 12),
          // 제목
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // FeedbackLabel 끝으로 이동
          Align(
            alignment: Alignment.centerRight, // Row 끝으로 정렬
            child: FeedbackLabel(
              label: label,
              backgroundColor: backgroundColor,
              textColor: textColor,
              dotColor: feedbackDotColor,
              width: 120.0, // 고정된 가로 길이
            ),
          ),
        ],
      ),
    );
  }
}
