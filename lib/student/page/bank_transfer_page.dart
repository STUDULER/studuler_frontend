import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/http/http_service.dart';
import '../../common/util/format_money.dart';

class BankTransferPage extends StatefulWidget {
  const BankTransferPage({
    super.key,
    required this.classId,
    required this.className,
    required this.date,
    required this.price,
  });

  final int classId;
  final String className;
  final Jiffy date;
  final int price;

  @override
  State<BankTransferPage> createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  String receiverName = "";
  String bankName = "";
  String bankAccount = "";

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    final responseMap = await HttpService().fetchPaymentInfo(
      classId: widget.classId,
    );
    receiverName = responseMap['name'] ?? "";
    bankName = responseMap['bank'] ?? "";
    bankAccount = responseMap['account'] ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(24),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  Gap(8),
                  const Text(
                    "무통장입금",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
              ), // 아무 것도 없을 때 좌우로 길게 늘리기 위한 목적
              Gap(56),
              Row(
                children: [
                  SizedBox(
                    child: Center(
                      child: Text(
                        widget.className,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox.shrink(),
                ],
              ),
              Gap(28),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 7 * 3,
                    child: Center(
                      child: Text(
                        "관련 정산일",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.date.format(pattern: 'yyyy/M/dd'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Gap(28),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 7 * 3,
                    child: Center(
                      child: Text(
                        "금액",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    formatMoney(widget.price),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Gap(28),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 7 * 3,
                    child: Center(
                      child: Text(
                        "받는분",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    receiverName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Gap(28),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 7 * 3,
                    child: Center(
                      child: Text(
                        "은행",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    bankName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Gap(28),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 7 * 3,
                    child: Center(
                      child: Text(
                        "계좌번호",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    bankAccount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(8),
                  GestureDetector(
                    onTap: _copyCodeToClipboard,
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      // color: Colo,
                    ),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  try {
                    // 1. 선생님 FCM 토큰 가져오기
                    final teacherFCM = await HttpService().fetchTeacherFCMByClassId(widget.classId);
                    if (teacherFCM == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("선생님 알림을 보낼 수 없습니다. 잠시 후 다시 시도해주세요."),
                        ),
                      );
                      return;
                    }

                    // 2. 클라우드 메시지 전송
                    final success = await HttpService().sendNotification(
                      teacherFCM,
                      "송금 완료 알림",
                      "${widget.className} 수업에 대한 송금이 완료되었습니다. 확인 부탁드립니다.",
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("선생님께 송금 완료 알림을 보냈습니다."),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("알림 전송에 실패했습니다. 다시 시도해주세요."),
                        ),
                      );
                    }
                  } catch (e) {
                    print("Error in sending notification: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("오류가 발생했습니다. 다시 시도해주세요."),
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xff878a8e),
                  ),
                  child: Center(
                    child: Text(
                      "송금완료",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Icon(
                      Icons.priority_high_outlined,
                      size: 22,
                    ),
                    Gap(2),
                    Column(
                      children: [
                        Text(
                          "송금 완료 시 위 버튼을 눌러",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.0,
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          "선생님께 송금 확인 알림을 보내세요.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.0,
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Gap(12),
            ],
          ),
        ),
      ),
    );
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: bankAccount));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Durations.medium4,
        content: Text("계좌번호가 복사되었습니다."),
      ),
    );
  }
}
