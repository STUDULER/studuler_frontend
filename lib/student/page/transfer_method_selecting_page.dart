import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TransferMethodSelectingPage extends StatelessWidget {
  const TransferMethodSelectingPage({super.key});

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
                    "송금 방법",
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

              Spacer(
                flex: 3,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // TODO - 카카오페이 송금하기로 이동
                    print("카카오페이 송금하기");
                  },
                  child: Container(
                    width: 232,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.amberAccent,
                    ),
                    child: Center(
                      child: Text(
                        "카카오페이 송금",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(24),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    // TODO - 무통장입금하기로 이동
                    print("무통장 입금");
                  },
                  child: Container(
                    width: 232,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(0xffe7e7e7),
                    ),
                    child: Center(
                      child: Text(
                        "무통장입금",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
