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

  bool showEmailError = false;
  bool showEmailEmptyError = false;
  bool showPasswordError = false;
  bool showPasswordEmptyError = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorTextStyle = TextStyle(fontSize: 12, color: Colors.red);
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
                    height: MediaQuery.sizeOf(context).height / 2.5,
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
                          if (showEmailError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "잘못된 메일 입니다. 다시 입력해주세요.",
                                style: errorTextStyle,
                              ),
                            ),
                          if (showEmailEmptyError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "이메일을 입력해주세요.",
                                style: errorTextStyle,
                              ),
                            ),
                          const Spacer(),
                          AuthTextField(
                            controller: _passwordController,
                            label: "비밀번호",
                            hintText: "비밀번호를 입력해주세요",
                            obscureText: true,
                          ),
                          if (showPasswordError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "잘못된 비밀번호 입니다. 다시 입력해주세요.",
                                style: errorTextStyle,
                              ),
                            ),
                          if (showPasswordEmptyError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "비밀번호를 입력해주세요.",
                                style: errorTextStyle,
                              ),
                            ),
                          const Spacer(),
                          GestureDectectorHidingKeyboard(
                            onTap: () async {
                              setState(() {
                                showEmailError = false;
                                showEmailEmptyError = false;
                                showPasswordError = false;
                                showPasswordEmptyError = false;
                              });
                              if (_idController.text.isEmpty) {
                                setState(() {
                                  showEmailEmptyError = true;
                                });
                                return;
                              }
                              if (_passwordController.text.isEmpty) {
                                setState(() {
                                  showPasswordEmptyError = true;
                                });
                                return;
                              }
                              final loginResult =
                                  await HttpService().loginWithMail(
                                isTeacher: widget.isTeacher,
                                mail: _idController.text,
                                password: _passwordController.text,
                              );
                              if (loginResult == null) {
                                setState(() {
                                  showEmailError = true;
                                });
                                return;
                              }
                              if (loginResult == false) {
                                setState(() {
                                  showPasswordError = true;
                                });
                                return;
                              }
                              if (loginResult == true) {
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BottomBar(
                                          isTeacher: widget.isTeacher,
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
