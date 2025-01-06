import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../auth/auth_service.dart';
import '../auth/auth_service_type.dart';
import '../auth/oauth_user_dto.dart';
import '../http/http_service.dart';
import '../section/login_with_email_or_sign_up_with_email_section.dart';
import '../section/yellow_background.dart';
import '../widget/app_title.dart';
import '../widget/bottom_bar.dart';
import 'account_input_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
    required this.isTeacher,
  });

  final HttpService _httpService = HttpService();
  final AuthService _authService = AuthService();
  final bool isTeacher;

  Future<void> handleSuccessAuthService(
    BuildContext context,
    OAuthUserDto dto,
    int loginMethod,
  ) async {
    if (isTeacher) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AccountInputPage(
            dto: dto,
            loginMethod: loginMethod,
          ),
        ),
        (route) => false,
      );
    } else {
      final httpResult = await _httpService.createParent(dto, loginMethod);
      if (httpResult == false) return;
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(isTeacher: isTeacher),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double bannerSize = 60;
    const double iconSize = 48;
    return Scaffold(
      body: YellowBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 2,
              ),
              const AppTitle(),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final result = await _authService.signIn(
                    authServiceType: AuthServiceType.kakao,
                    role: isTeacher,
                  );
                  if (result == null) return;
                  if (!context.mounted) return;
                  await handleSuccessAuthService(context, result, 1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffFEE500),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: bannerSize,
                  child: Row(
                    children: [
                      const Gap(bannerSize-iconSize),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: iconSize,
                          child: Image.asset('assets/kakaotalk.png')),
                      ),
                      const Spacer(),
                      const Text(
                        "카카오로 시작하기",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: bannerSize,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await _authService.signIn(
                    authServiceType: AuthServiceType.google,
                    role: isTeacher,
                  );
                  if (result == null) return;
                  if (!context.mounted) return;
                  await handleSuccessAuthService(context, result, 2);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 245, 245, 245),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: bannerSize,
                  child: Row(
                    children: [
                      const Gap(bannerSize-iconSize),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: iconSize,
                          child: Image.asset('assets/google_square_icon.png')),
                      ),
                      const Spacer(),
                      const Text(
                        "Google로 시작하기",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const Gap(bannerSize),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              LoginWithEmailOrSignUpWithEmailSection(
                isTeacher: isTeacher,
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
