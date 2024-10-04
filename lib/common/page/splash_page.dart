import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studuler/common/page/role_selection_page.dart';

import '../../main.dart';
import '../auth/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showSplash = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: _showSplash ? Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xffFFEC9E),
                    Color(0xffB7CADB),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const Spacer(
                  flex: 2,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      "STUDULER",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ],
        ) : FutureBuilder(
          future: _authService.autoLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data == true
                  ? const MyHomePage(
                      title: "dummy",
                    )
                  : const RoleSelectionPage();
            }
          },
        ),
      ),
    );
  }
}
