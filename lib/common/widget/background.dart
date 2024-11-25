import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.iconActionButtons,
  });

  final List<IconButton> iconActionButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // 배경 높이
      decoration: BoxDecoration(
        color: Colors.yellow[200],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40, // 원하는 위치로 조정
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'STUDULER',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: iconActionButtons,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
