import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../auth/oauth_user_dto.dart';
import '../http/http_service.dart';
import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import '../widget/app_title.dart';
import '../widget/bottom_bar.dart';
import 'kakao_pay_qr_instruction_page.dart';

class KakaoPayQrInputPage extends StatefulWidget {
  const KakaoPayQrInputPage({
    super.key,
    required this.dto,
    required this.loginMethod,
    required this.name,
    required this.bank,
    required this.account,
  });

  final OAuthUserDto dto;
  final int loginMethod;
  final String name;
  final String bank;
  final String account;

  @override
  State<KakaoPayQrInputPage> createState() => _KakaoPayQrInputPageState();
}

class _KakaoPayQrInputPageState extends State<KakaoPayQrInputPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          Gap(8),
                          Text(
                            "카카오페이로 정산을 원하실 경우 링크를 기재해주세요",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Row(
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
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "https://qr.kakaopay.com/example",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                          Gap(16),
                          GestureDectectorHidingKeyboard(
                            onTap: () async {
                              final result = await HttpService().createTeacher(
                                dto: widget.dto,
                                bank: widget.bank,
                                account: widget.account,
                                name: widget.name,
                                loginMethod: widget.loginMethod,
                                kakaoId: "",
                                kakaoQrUrl: _controller.text,
                              );
                              if (result == false) return;
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomBar(
                                    isTeacher: true,
                                  ),
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
