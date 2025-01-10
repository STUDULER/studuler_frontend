import 'package:flutter/material.dart';

import '../http/http_service.dart';
import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import '../widget/app_title.dart';
import '../widget/auth_text_field.dart';
import '../widget/bottom_bar.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({
    super.key,
    required this.isTeacher,
  });

  final bool isTeacher;

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            controller: _idController,
                            label: "이메일 아이디",
                            hintText: "아이디를 입력해주세요",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const Spacer(),
                          AuthTextField(
                            controller: _passwordController,
                            label: "비밀번호",
                            hintText: "비밀번호를 입력해주세요",
                            obscureText: true,
                          ),
                          const Spacer(),
                          GestureDectectorHidingKeyboard(
                            onTap: () async {
                              if (_idController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                return;
                              }
                              if (await HttpService().loginWithMail(
                                isTeacher: widget.isTeacher,
                                mail: _idController.text,
                                password: _passwordController.text,
                              )) {
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BottomBar(
                                          isTeacher: true,
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
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
                                  "로그인",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
