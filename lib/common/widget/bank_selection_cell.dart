import 'package:flutter/material.dart';

import '../util/gesture_dectector_hiding_keyboard.dart.dart';

class BankSelectionCell extends StatelessWidget {
  const BankSelectionCell({
    super.key,
    required this.bank,
    required this.controller,
  });

  final String bank;
  final TextEditingController controller;

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
            const Icon(Icons.ac_unit),
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
