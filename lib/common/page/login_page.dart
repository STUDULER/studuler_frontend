import 'package:flutter/material.dart';
import 'package:studuler/common/auth/auth_service_type.dart';

import '../auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async => _authService.signIn(
                authServiceType: AuthServiceType.kakao,
              ),
              child: Container(
                color: Colors.amber,
                width: 300,
                height: 200,
              ),
            ),
            GestureDetector(
              onTap: () async => _authService.signIn(
                authServiceType: AuthServiceType.google,
              ),
              child: Container(
                color: Colors.blue,
                width: 300,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
