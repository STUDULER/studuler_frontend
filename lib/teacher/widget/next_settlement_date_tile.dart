import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/model/next_settlment.dart';

class NextSettlementDateTile extends StatelessWidget {
  const NextSettlementDateTile({
    super.key,
    required this.nextSettlment,
  });

  final NextSettlment nextSettlment;

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
              Text(
                nextSettlment.isUnpaid ? "다음 정산일" : "미리 정산된 회차",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                nextSettlment.date.format(
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
