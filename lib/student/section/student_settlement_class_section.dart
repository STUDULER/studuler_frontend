import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/model/class_settlement.dart';
import '../../common/util/get_color_by_index.dart';
import '../../common/widget/last_settlement_date_tile.dart';
import '../../common/widget/next_settlement_date_tile.dart';

class StudentSettlementClassSection extends StatelessWidget {
  const StudentSettlementClassSection({
    super.key,
    required this.classSettlement, 
    required this.rebuild,
  });

  final ClassSettlement classSettlement;
  final Function rebuild;

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
            classId: classSettlement.classId,
            isTeacher: false,
            lastSettlement: classSettlement.lastSettlements.elementAt(
              index,
            ),
            rebuild: rebuild,
          ),
        ),
        NextSettlementDateTile(
          isTeacher: false,
          nextSettlment: classSettlement.nextSettlment,
        ),
        const Gap(32),
      ],
    );
  }
}
