import 'package:flutter/material.dart';

import '../../main.dart';
import '../auth/oauth_user_dto.dart';
import '../http/http_service.dart';
import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import '../widget/app_title.dart';
import '../widget/auth_text_field.dart';
import 'bank_selection_page.dart';

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

  final _bankController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _textfieldController = TextEditingController();
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
    _bankController.dispose();
    _textfieldController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDectectorHidingKeyboard(
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
                    height: MediaQuery.sizeOf(context).height / 3,
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
                          const Spacer(),
                          AuthTextField(
                            controller: _accountNumberController,
                            label: "계좌번호 입력",
                            hintText: "계좌번호를 입력해주세요",
                            keyboardType: TextInputType.number,
                          ),
                          const Spacer(),
                          GestureDectectorHidingKeyboard(
                            onTap: () async {
                              if (_bankController.text.isEmpty ||
                                  _accountNumberController.text.isEmpty) {
                                return;
                              }
                              final result = await httpservice.createTeacher(
                                widget.dto,
                                _bankController.text,
                                _accountNumberController.text,
                                widget.loginMethod,
                              );
                              if (result == false) return;
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: "선생님"),
                                ),
                                (route) => false,
                              );
                            },
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
                                  "회원가입 완료",
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
    );
  }
}
