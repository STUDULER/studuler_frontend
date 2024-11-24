import 'package:flutter/material.dart';

class CalendarDateSection extends StatelessWidget {
  const CalendarDateSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("일", style: TextStyle(color: Colors.red)),
        Text("월"),
        Text("화"),
        Text("수"),
        Text("목"),
        Text("금"),
        Text("토", style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}