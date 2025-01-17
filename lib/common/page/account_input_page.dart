import 'package:flutter/material.dart';

import '../auth/oauth_user_dto.dart';
import '../http/http_service.dart';
import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import '../widget/app_title.dart';
import '../widget/auth_text_field.dart';
import 'bank_selection_page.dart';
import 'kakao_pay_qr_input_page.dart';

class AccountInputPage extends StatefulWidget {
  const AccountInputPage({
    super.key,
    required this.dto,
    required this.loginMethod,
  });

  final OAuthUserDto dto;
  final int loginMethod;

  @override
  State<AccountInputPage> createState() => _AccountInputPageState();
}

class _AccountInputPageState extends State<AccountInputPage> {
  final httpservice = HttpService();

  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _textfieldController = TextEditingController();

  bool showNameEmptyError = false;
  bool showBankEmptyError = false;
  bool showAccountNumberEmptyError = false;

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

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _textfieldController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorTextStyle = TextStyle(fontSize: 12, color: Colors.red);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: GestureDectectorHidingKeyboard(
            child: YellowBackground(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      const AppTitle(),
                      const Spacer(),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height / 2,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthTextField(
                                controller: _nameController,
                                label: "예금주 성명",
                                hintText: "이름을 입력해주세요",
                              ),
                              if (showNameEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "에금주 성명은 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
                              AuthTextField(
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
                                        textfieldController:
                                            _textfieldController,
                                        banks: _banks,
                                      );
                                    },
                                  );
                                },
                              ),
                              if (showBankEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "은행 필수 선택사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
                              AuthTextField(
                                controller: _accountNumberController,
                                label: "계좌번호 입력",
                                hintText: "계좌번호를 입력해주세요",
                                keyboardType: TextInputType.number,
                              ),
                              if (showAccountNumberEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "계좌번호는 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KakaoPayQrInputPage(
                                        dto: widget.dto,
                                        loginMethod: widget.loginMethod,
                                        name: _nameController.text,
                                        bank: _bankController.text,
                                        account: _accountNumberController.text,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height / 16,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: Colors.brown,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "다음",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
