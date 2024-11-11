import 'package:flutter/material.dart';

class TeacherSchedulePage extends StatelessWidget {
  const TeacherSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스케줄 페이지'),
      ),
      body: const Center(
        child: Text('스케줄 페이지 내용'),
      ),
    );
  }
}
