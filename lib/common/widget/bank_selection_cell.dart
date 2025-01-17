import 'package:flutter/material.dart';

import '../util/gesture_dectector_hiding_keyboard.dart.dart';

class BankSelectionCell extends StatelessWidget {
  const BankSelectionCell({
    super.key,
    required this.bank,
    required this.controller,
    required this.bankLogos,
  });

  final String bank;
  final TextEditingController controller;
  final Map<String, String> bankLogos;


  @override
  Widget build(BuildContext context) {
    return GestureDectectorHidingKeyboard(
      onTap: () {
        controller.text = bank;
        Navigator.of(context).pop();
      },
      child: SizedBox(
        child: Row(
          children: [
            Image.asset(
              'assets/banks/${bankLogos[bank]}', // 은행 이름을 기반으로 이미지 로드
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(bank),
          ],
        ),
      ),
    );
  }
}
