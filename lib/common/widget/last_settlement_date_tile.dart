import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../student/page/transfer_method_selecting_page.dart';
import '../http/http_service.dart';
import '../util/format_money.dart';
import '../model/last_settlement.dart';
import 'show_studuler_dialog.dart';

class LastSettlementDateTile extends StatelessWidget {
  const LastSettlementDateTile({
    super.key,
    required this.classId,
    required this.className,
    required this.lastSettlement,
    required this.isTeacher,
    required this.rebuild,
  });

  final int classId;
  final String className;
  final LastSettlement lastSettlement;
  final Function rebuild;
  final bool isTeacher;

  Widget teacherButton(BuildContext context) {
    if (!lastSettlement.isPaid) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await showStudulerDialog(
                context,
                "학부모님께 정산 알림을\n보내시겠습니까?",
                Column(
                  children: [
                    Text(
                      "정산일: ${lastSettlement.date.format(
                        pattern: 'yyyy/M/dd',
                      )}",
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      "금액: ${formatMoney(lastSettlement.price)}원}",
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
                () {
                  // TODO - 정산 알림 보내기
                  print('정산 알림 보내기');
                },
              );
            },
            child: Container(
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
          ),
          Gap(4),
          GestureDetector(
            onTap: () async {
              await showStudulerDialog(
                context,
                "정산 내역을\n확인하셨습니까?",
                Column(
                  children: [
                    Text(
                      "정산일: ${lastSettlement.date.format(
                        pattern: 'yyyy/M/dd',
                      )}",
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      "금액: ${formatMoney(lastSettlement.price)}원}",
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      "'확인' 클릭 시 해당 동작은 되돌릴 수 없습니다.",
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
                () async {
                  final result = await HttpService().updateClassAsPaid(
                    classId: classId,
                    paidDate: lastSettlement.date,
                  );
                  if (result) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      rebuild();
                    }
                  }
                },
                height: 190,
              );
            },
            child: Container(
              width: 102,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFC7B7A3).withOpacity(
                  0.34,
                ),
              ),
              child: const Center(
                child: Text(
                  "정산 완료",
                  style: TextStyle(
                    color: Color(0xFFC7B7A3),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget studentButton(BuildContext context) {
    if (!lastSettlement.isPaid) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransferMethodSelectingPage(
                    classId: classId,
                    className: className,
                    date: lastSettlement.date,
                    price: lastSettlement.price,
                  ),
                ),
              );
            },
            child: Container(
              width: 102,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFC7B7A3),
              ),
              child: const Center(
                child: Text(
                  "송금하기",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

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
            if (isTeacher) teacherButton(context) else studentButton(context),
          ],
        ),
      ),
    );
  }
}
