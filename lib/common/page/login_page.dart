import 'package:flutter/material.dart';
import 'package:studuler/main.dart';

import '../auth/auth_service.dart';
import '../auth/auth_service_type.dart';
import '../http/http_service.dart';
import '../section/login_with_email_or_sign_in_section.dart';
import '../section/sign_up_with_email_or_login_section.dart';
import '../section/yellow_background.dart';
import 'account_input_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
    required this.isTeacher,
    required this.showLoginWithEmail,
  });

  final HttpService _httpService = HttpService();
  final AuthService _authService = AuthService();
  final bool isTeacher;
  final bool showLoginWithEmail;

  Future<void> handleSuccessAuthService(BuildContext context) async {
    if (isTeacher) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountInputPage(),
        ),
        (route) => false,
      );
    } else {
      final httpResult = await _httpService.createParent(
        "dummyName",
      );
      if (httpResult == false) return;
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "학부모"),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YellowBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 2,
              ),
              Text(
                "STUDULER",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final result = await _authService.signIn(
                    authServiceType: AuthServiceType.kakao,
                  );
                  if (result == false) return;
                  if (!context.mounted) return;
                  await handleSuccessAuthService(context);
                },
                child: Container(
                  color: Colors.amber,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 70,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await _authService.signIn(
                    authServiceType: AuthServiceType.google,
                  );
                  if (result == false) return;
                  if (!context.mounted) return;
                  await handleSuccessAuthService(context);
                },
                child: Container(
                  color: Colors.blue,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 70,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              showLoginWithEmail
                  ? LoginWithEmailOrSignInSection(
                      isTeacher: isTeacher,
                    )
                  : SignUpWithEmailOrLoginSection(
                      isTeacher: isTeacher,
                    ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
