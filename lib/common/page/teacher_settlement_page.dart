import 'package:flutter/material.dart';

class TeacherSettlementPage extends StatelessWidget {
  const TeacherSettlementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 오타 수정: Scafold -> Scaffold
      appBar: AppBar(
        title: const Text('정산하기 페이지'),
      ),
      body: const Center(
        child: Text('정산하기 페이지 내용'),
      ),
    );
  }
}
