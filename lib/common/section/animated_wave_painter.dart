import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedWavePainter extends CustomPainter {
  final double progress;
  final Animation<double> animation;
  final Color waveColor;

  AnimatedWavePainter({
    required this.progress,
    required this.animation,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = waveColor.withOpacity(0.5);

    // 물결의 높이를 진행도에 따라 설정
    final waveHeight = size.height * (1 - progress);
    final waveWidth = size.width;
    final path = Path();

    // 더 촘촘한 물결을 위해 주기를 증가시킴
    const waveFrequency = 5; // 이 값을 높일수록 물결이 더 촘촘해짐

    for (double i = 0; i <= waveWidth; i++) {
      final x = i;
      final y = waveHeight + 3 * sin((i / waveWidth * waveFrequency * pi) + animation.value * 2 * pi);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
