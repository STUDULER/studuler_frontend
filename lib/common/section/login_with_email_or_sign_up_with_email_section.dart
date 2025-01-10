import 'package:flutter/material.dart';

import '../page/login_with_email_page.dart';
import '../page/sign_up_with_email_page.dart';

class LoginWithEmailOrSignUpWithEmailSection extends StatelessWidget {
  const LoginWithEmailOrSignUpWithEmailSection({
    super.key,
    required this.isTeacher,
  });

  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginWithEmailPage(
                isTeacher: isTeacher,
              ),
            ),
          ),
          child: const Text("이메일로 로그인"),
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          width: 1,
          height: 16,
          color: Colors.black,
        ),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpWithEmailPage(
                isTeacher: isTeacher,
              ),
            ),
          ),
          child: const Text("이메일로 회원가입"),
        ),
        const Spacer(),
      ],
    );
  }
}
