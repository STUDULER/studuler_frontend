import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/util/format_money.dart';
import '../../common/model/last_settlement.dart';

class LastSettlementDateTile extends StatelessWidget {
  const LastSettlementDateTile({
    super.key, 
    required this.lastSettlement,
  });

  final LastSettlement lastSettlement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lastSettlement.isPaid
                ? const Icon(
                    Icons.check_rounded,
                    size: 28,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.close_rounded,
                    size: 28,
                    color: Colors.red,
                  ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "지난 정산일",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  lastSettlement.date.format(
                    pattern: 'yyyy/M/dd',
                  ),
                ),
                Text("${formatMoney(lastSettlement.price)}원"),
              ],
            ),
            const Spacer(),
            if (!lastSettlement.isPaid)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 102,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFC7B7A3),
                    ),
                    child: const Center(
                      child: Text(
                        "알림 보내기",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
