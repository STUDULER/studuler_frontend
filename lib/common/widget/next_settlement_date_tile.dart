import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../student/page/transfer_method_selecting_page.dart';
import '../http/http_service.dart';
import '../model/next_settlment.dart';
import '../util/format_money.dart';
import 'show_studuler_dialog.dart';

class NextSettlementDateTile extends StatelessWidget {
  const NextSettlementDateTile({
    super.key,
    required this.classId,
    required this.className,
    required this.nextSettlment,
    required this.isTeacher,
    required this.rebuild,
  });

  final int classId;
  final String className;
  final NextSettlment nextSettlment;
  final bool isTeacher;
  final Function rebuild;

  Widget teacherButton(BuildContext context) {
    if (nextSettlment.isUnpaid) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await showStudulerDialog(
                context,
                "정산 내역을\n확인하셨습니까?",
                Column(
                  children: [
                    Text(
                      "정산일: ${nextSettlment.date.format(
                        pattern: 'yyyy/M/dd',
                      )}",
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      "금액: ${formatMoney(nextSettlment.price)}원}",
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
                    paidDate: nextSettlment.date,
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
    if (nextSettlment.isUnpaid) {
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
                    date: nextSettlment.date,
                    price: nextSettlment.price,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 28,
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          Spacer(),
          isTeacher ? teacherButton(context) : studentButton(context),
        ],
      ),
    );
  }
}
