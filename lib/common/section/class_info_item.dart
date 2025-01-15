import 'package:flutter/material.dart';

class ClassInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ClassInfoItem({
    required this.icon,
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0), // 위아래 여백 추가
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 아이콘과 텍스트 정렬
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // 아이콘 위치 아래로 이동
            child: Icon(icon, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // 최대 두 줄로 제한
                  overflow: TextOverflow.ellipsis, // 넘칠 경우 생략 표시
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
