import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../auth/oauth_user_dto.dart';
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
  bool showNameEmptyError = false;
  bool showEmailEmptyError = false;
  bool showEmailValidationError = false;
  bool showEmailDuplicatedError = false;
  bool showPasswordEmptyError = false;
  bool showPasswordCheckEmptyError = false;
  bool showPasswordCheckValidationError = false;

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
                              if (showNameEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "이름은 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
                              AuthTextField(
                                controller: _emailController,
                                label: "이메일",
                                hintText: "이메일을 입력해주세요",
                                keyboardType: TextInputType.emailAddress,
                              ),
                              if (showEmailEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "이메일은 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              if (showEmailValidationError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "이메일 주소를 확인해주세요",
                                    style: errorTextStyle,
                                  ),
                                ),
                              if (showEmailDuplicatedError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "이미 존재하는 이메일 입니다",
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
                              if (showPasswordEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "비밀번호는 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
                              AuthTextField(
                                controller: _passwordCheckController,
                                label: "비밀번호 확인",
                                hintText: "비밀번호를 입력해주세요",
                                obscureText: true,
                              ),
                              if (showPasswordCheckValidationError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "비밀번호 확인이 비밀 번호와 달라요",
                                    style: errorTextStyle,
                                  ),
                                ),
                              if (showPasswordCheckEmptyError)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "비밀번호 확인은 필수 입력사항입니다",
                                    style: errorTextStyle,
                                  ),
                                ),
                              const Spacer(),
                              GestureDectectorHidingKeyboard(
                                onTap: () async {
                                  setState(() {
                                    showNameEmptyError = false;
                                    showEmailEmptyError = false;
                                    showEmailValidationError = false;
                                    showEmailDuplicatedError = false;
                                    showPasswordEmptyError = false;
                                    showPasswordCheckEmptyError = false;
                                    showPasswordCheckValidationError = false;
                                  });
                                  if (_nameController.text.isEmpty) {
                                    setState(() {
                                      showNameEmptyError = true;
                                    });
                                    return;
                                  }
                                  if (_emailController.text.isEmpty) {
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
                                  if (_passwordCheckController.text.isEmpty) {
                                    setState(() {
                                      showPasswordCheckEmptyError = true;
                                    });
                                    return;
                                  }
                                  if (!EmailValidator.validate(
                                    _emailController.text,
                                  )) {
                                    setState(() {
                                      showEmailValidationError = true;
                                    });
                                    return;
                                  }
                                  final emailDuplcatedSafe =
                                      await httpService.checkMail(
                                    mail: _emailController.text,
                                    isTeacher: widget.isTeacher,
                                  );
                                  if (!emailDuplcatedSafe) {
                                    setState(() {
                                      showEmailDuplicatedError = true;
                                    });
                                    return;
                                  }
                                  if (!isSamePassword()) {
                                    setState(() {
                                      showPasswordCheckValidationError = true;
                                    });
                                    return;
                                  }
                                  const emailLoginMethod = 0;
                                  final dto = OAuthUserDto(
                                    username: _nameController.text,
                                    password: _passwordController.text,
                                    mail: _emailController.text,
                                    image: 0,
                                  );
                                  if (widget.isTeacher) {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AccountInputPage(
                                            dto: dto,
                                            loginMethod: emailLoginMethod,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    final result =
                                        await httpService.createParent(
                                      dto: dto,
                                      loginMethod: emailLoginMethod,
                                    );
                                    if (result == false) return;
                                    if (!context.mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginWithEmailPage(
                                          isTeacher: widget.isTeacher,
                                        ),
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
