import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/model/class_settlement.dart';
import '../widget/last_settlement_date_tile.dart';
import '../widget/next_settlement_date_tile.dart';

class TeacherSettlementClassSection extends StatelessWidget {
  const TeacherSettlementClassSection({
    super.key,
    required this.classSettlement,
  });

  final ClassSettlement classSettlement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.bookmark,
              size: 36,
              color: Colors.blueGrey.shade400,
            ),
            const Gap(4),
            Text(
              classSettlement.className,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const Divider(),
        ...List<Widget>.generate(
          classSettlement.lastSettlements.length,
          (index) => LastSettlementDateTile(
            lastSettlement: classSettlement.lastSettlements.elementAt(
              index,
            ),
          ),
        ),
        NextSettlementDateTile(
          date: classSettlement.nextSettlment.date,
        ),
        const Gap(32),
      ],
    );
  }
}
