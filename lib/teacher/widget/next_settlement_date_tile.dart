import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

class NextSettlementDateTile extends StatelessWidget {
  const NextSettlementDateTile({
    super.key,
    required this.date,
  });

  final Jiffy date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 28,
          ),
          const Gap(12),
          Column(
            children: [
              const Text(
                "다음 정산일",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date.format(
                  pattern: 'yyyy/M/dd',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
