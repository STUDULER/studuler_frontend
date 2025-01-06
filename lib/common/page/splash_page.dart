import 'dart:async';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../widget/app_title.dart';
import '../widget/bottom_bar.dart';
import 'role_selection_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showSplash = true;
  final AuthService _authService = AuthService();

  final Duration splashDuration = const Duration(
    seconds: 2,
    milliseconds: 500,
  );

  @override
  void initState() {
    super.initState();

    Timer(splashDuration, () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedSwitcher(
        duration: Durations.extralong1,
        child: _showSplash
            ? SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: AnimateGradient(
                  reverse: false,
                  duration: splashDuration,
                  primaryBegin: Alignment.topCenter,
                  primaryEnd: Alignment.topCenter,
                  secondaryBegin: Alignment.bottomCenter,
                  secondaryEnd: Alignment.topCenter,
                  primaryColors: [
                    const Color(0xffB7CADB),
                    const Color(0xffB7CADB),
                    const Color(0xffB7CADB),
                    const Color(0xffB7CADB),
                    const Color(0xffB7CADB),
                    const Color(0xffB7CADB),
                    Colors.yellow.shade200,
                  ],
                  secondaryColors: [
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                    Colors.yellow.shade200,
                  ],
                  child: const Column(
                    children: [
                      Spacer(
                        flex: 2,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          AppTitle(),
                          Spacer(),
                        ],
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
              )
            : FutureBuilder(
                future: _authService.autoLogin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data == true
                        ? FutureBuilder(
                            future: _authService.isTeacher(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.data == true) {
                                return BottomBar(isTeacher: true);
                              } else {
                                return BottomBar(isTeacher: false);
                              }
                            },
                          )
                        : const RoleSelectionPage();
                  }
                },
              ),
      ),
    );
  }
}
