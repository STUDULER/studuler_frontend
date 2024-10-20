import 'package:flutter/material.dart';
import 'package:studuler/common/page/login_page.dart';

class LoginWithEmailOrSignInSection extends StatelessWidget {
  const LoginWithEmailOrSignInSection({
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
          onTap: () {},
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
              builder: (context) => LoginPage(
                isTeacher: isTeacher,
                showLoginWithEmail: false,
              ),
            ),
          ),
          child: const Text("회원가입"),
        ),
        const Spacer(),
      ],
    );
  }
}
