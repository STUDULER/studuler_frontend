import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "STUDULER",
      style: TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.bold,
        fontFamily: 'GowunDodum',
      ),
    );
  }
}
