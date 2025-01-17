import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/http/http_service.dart';
import '../../common/page/bank_selection_page.dart';
import '../../common/page/kakao_pay_qr_instruction_page.dart';
import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/auth_text_field.dart';
import '../model/account_info.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  final List<String> _banks = [
    "카카오뱅크",
    "국민은행",
    "기업은행",
    "농협은행",
    "신한은행",
    "산업은행",
    "우리은행",
    "한국씨티은행",
    "하나은행",
    "SC제일은행",
    "경남은행",
    "광주은행",
    "대구은행",
    "도이치은행",
    "뱅크오브아메리카",
    "부산은행",
    "신림조합중앙회",
    "저축은행",
  ];

  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _textfieldController = TextEditingController();
  final _kakaoQrLinkController = TextEditingController();
  late AccountInfo accountInfo;

  bool showNameEmptyError = false;
  bool showBankEmptyError = false;
  bool showAccountNumberEmptyError = false;

  @override
  void initState() {
    super.initState();
    initBuild();
  }

  Future<void> initBuild() async {
    accountInfo = await HttpService().getAccountInfo();
    _nameController.text = accountInfo.name;
    _bankController.text = accountInfo.bank;
    _accountNumberController.text = accountInfo.account;
    _kakaoQrLinkController.text = accountInfo.kakaopayLink;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _textfieldController.dispose();
    _accountNumberController.dispose();
    _kakaoQrLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorTextStyle = TextStyle(fontSize: 12, color: Colors.red);
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDectectorHidingKeyboard(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
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
                        "계좌 관리",
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

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AuthTextField(
                      controller: _nameController,
                      label: "예금주 성명",
                      hintText: "이름을 입력해주세요",
                    ),
                  ),
                  if (showNameEmptyError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "에금주 성명은 필수 입력사항입니다",
                        style: errorTextStyle,
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AuthTextField(
                      controller: _bankController,
                      label: "은행",
                      hintText: "은행을 선택해주세요",
                      readOnly: true,
                      showCursor: false,
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          builder: (context) {
                            return BankSelectionPage(
                              bankController: _bankController,
                              textfieldController: _textfieldController,
                              banks: _banks,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (showBankEmptyError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "은행은 필수 선택사항입니다",
                        style: errorTextStyle,
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AuthTextField(
                      controller: _accountNumberController,
                      label: "계좌번호 입력",
                      hintText: "계좌번호를 입력해주세요",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  if (showAccountNumberEmptyError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "계좌번호는 필수 입력사항입니다",
                        style: errorTextStyle,
                      ),
                    ),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '카카오페이 송금 QR 링크',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              TextSpan(
                                text: ' (선택사항)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "카카오페이로 정산을 원하실 경우 링크를 기재해주세요",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "송금 링크 가이드가 필요하다면 물음표를 눌러주세요",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Gap(4),
                              GestureDectectorHidingKeyboard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          KakaoPayQrInstructionPage(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.question_mark_rounded,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: _kakaoQrLinkController,
                            decoration: InputDecoration(
                              hintText: "https://qr.kakaopay.com/example",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDectectorHidingKeyboard(
                    onTap: () async {
                      setState(() {
                        showNameEmptyError = false;
                        showBankEmptyError = false;
                        showAccountNumberEmptyError = false;
                      });
                      if (_nameController.text.isEmpty) {
                        setState(() {
                          showNameEmptyError = true;
                        });
                        return;
                      }
                      if (_bankController.text.isEmpty) {
                        setState(() {
                          showBankEmptyError = true;
                        });
                        return;
                      }
                      if (_accountNumberController.text.isEmpty) {
                        setState(() {
                          showAccountNumberEmptyError = true;
                        });
                        return;
                      }
                      await HttpService().updateAccountInfo(
                        accountInfo: AccountInfo(
                          name: _nameController.text,
                          bank: _bankController.text,
                          account: _accountNumberController.text,
                          kakaopayLink: _kakaoQrLinkController.text,
                        ),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      // final result = await HttpService().createTeacher(
                      //   dto: widget.dto,
                      //   bank: widget.bank,
                      //   account: widget.account,
                      //   name: widget.name,
                      //   loginMethod: widget.loginMethod,
                      //   kakaoId: "",
                      //   kakaoQrUrl: _controller.text,
                      // );
                      // if (result == false) return;
                      // if (!context.mounted) return;
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BottomBar(
                      //       isTeacher: true,
                      //     ),
                      //   ),
                      //   (route) => false,
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height / 16,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.brown,
                        ),
                        child: const Center(
                          child: Text(
                            "수정하기",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
