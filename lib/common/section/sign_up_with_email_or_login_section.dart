import 'package:flutter/material.dart';

class SignUpWithEmailOrLoginSection extends StatelessWidget {
  const SignUpWithEmailOrLoginSection({
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
          child: const Text("이메일로 회원가입"),
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
          onTap: () => Navigator.pop(context),
          child: const Text("로그인"),
        ),
        const Spacer(),
      ],
    );
  }
}
