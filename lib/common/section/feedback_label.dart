import 'package:flutter/material.dart';

// 피드백 라벨을 위한 위젯
class FeedbackLabel extends StatelessWidget {
  final String label; // 라벨 텍스트 (예: "피드백 완료", "피드백 미완료")
  final Color backgroundColor; // 배경 색상
  final Color textColor; // 텍스트 색상
  final Color dotColor; // 조그마한 원의 색상
  final double width; // 고정 가로 길이

  const FeedbackLabel({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.dotColor,
    this.width = 120.0, // 기본 고정 가로 길이
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // 고정된 가로 길이
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor, // 배경 색상 적용
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: backgroundColor, width: 1), // 테두리
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: [
          CircleAvatar(
            backgroundColor: dotColor, // 조그마한 원의 색상
            radius: 5, // 작은 원 크기
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor, // 글자 색상
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
