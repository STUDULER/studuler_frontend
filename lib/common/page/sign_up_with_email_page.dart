import 'package:flutter/material.dart';

import '../section/yellow_background.dart';
import '../util/gesture_dectector_hiding_keyboard.dart.dart';
import 'account_input_page.dart';
import 'login_with_email_page.dart';

class SignUpWithEmailPage extends StatefulWidget {
  const SignUpWithEmailPage({super.key, required this.isTeacher});

  final bool isTeacher;

  @override
  State<SignUpWithEmailPage> createState() => _SignUpWithEmailPageState();
}

class _SignUpWithEmailPageState extends State<SignUpWithEmailPage> {
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
                      Text(
                        "STUDULER",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
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
                              Text(
                                "이름",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: "이름을 입력해주세요",
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "이메일",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "이메일을 입력해주세요",
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "비밀번호",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "비밀번호를 입력해주세요",
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "비밀번호 확인",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextField(
                                controller: _passwordCheckController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "비밀번호를 입력해주세요",
                                ),
                              ),
                              const Spacer(),
                              GestureDectectorHidingKeyboard(
                                onTap: () {
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountInputPage(),
                                      ),
                                    );
                                  } else {
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
