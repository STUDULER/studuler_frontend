import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/model/class_settlement.dart';
import '../../common/util/get_color_by_index.dart';
import '../../common/widget/last_settlement_date_tile.dart';
import '../../common/widget/next_settlement_date_tile.dart';

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
              color: getColorByIndex(classSettlement.classColor),
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
            isTeacher: true,
            lastSettlement: classSettlement.lastSettlements.elementAt(
              index,
            ),
          ),
        ),
        NextSettlementDateTile(
          isTeacher: true,
          nextSettlment: classSettlement.nextSettlment,
        ),
        const Gap(32),
      ],
    );
  }
}
