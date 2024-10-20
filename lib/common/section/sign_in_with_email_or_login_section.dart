import 'package:flutter/material.dart';

class SignInWithEmailOrLoginSection extends StatelessWidget {
  const SignInWithEmailOrLoginSection({super.key});

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
          onTap: () {},
          child: const Text("로그인"),
        ),
        const Spacer(),
      ],
    );
  }
}
