import 'package:flutter/material.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import '../http/http_service.dart';
import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import '../widget/app_title.dart';
import '../widget/auth_text_field.dart';
import 'account_input_page.dart';
import 'login_with_email_page.dart';

class SignUpWithEmailPage extends StatefulWidget {
  const SignUpWithEmailPage({super.key, required this.isTeacher});

  final bool isTeacher;

  @override
  State<SignUpWithEmailPage> createState() => _SignUpWithEmailPageState();
}

class _SignUpWithEmailPageState extends State<SignUpWithEmailPage> {
  final httpService = HttpService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  bool isSamePassword() {
    if (_passwordController.text.length !=
        _passwordCheckController.text.length) {
      return false;
    }
    if (!_passwordController.text.contains(_passwordCheckController.text)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.isTeacher ? "다음" : "회원가입";
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
                        height: MediaQuery.sizeOf(context).height / 1.7,
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
                                label: "이름",
                                hintText: "이름을 입력해주세요",
                              ),
                              const Spacer(),
                              AuthTextField(
                                controller: _emailController,
                                label: "이메일",
                                hintText: "이메일을 입력해주세요",
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
                              AuthTextField(
                                controller: _passwordCheckController,
                                label: "비밀번호 확인",
                                hintText: "비밀번호를 입력해주세요",
                                obscureText: true,
                              ),
                              const Spacer(),
                              GestureDectectorHidingKeyboard(
                                onTap: () async {
                                  if (_nameController.text.isEmpty ||
                                      _emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty ||
                                      _passwordCheckController.text.isEmpty) {
                                    return;
                                  }
                                  if (!isSamePassword()) {
                                    return;
                                  }
                                  if (widget.isTeacher) {
                                    final dto = OAuthUserDto(
                                      username: _nameController.text,
                                      password: _passwordController.text,
                                      mail: _emailController.text,
                                      image: 1,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AccountInputPage(
                                          dto: dto,
                                          loginMethod: 3,
                                        ),
                                      ),
                                    );
                                  } else {
                                    final result =
                                        await httpService.createParent(
                                      "dummyName",
                                    );
                                    if (result == false) return;
                                    if (!context.mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginWithEmailPage(),
                                      ),
                                    );
                                  }
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
                                  child: Center(
                                    child: Text(
                                      buttonText,
                                      style: const TextStyle(
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
        ),
      ),
    );
  }
}
