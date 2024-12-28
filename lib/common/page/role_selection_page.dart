import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../section/yellow_background.dart';
import '../widget/app_title.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

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
              const AppTitle(),
              Text(
                "당신의 역할을 선택해주세요",
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              isTeacher: true,
                              showLoginWithEmail: true,
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          height: MediaQuery.sizeOf(context).width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(128),
                            ),
                            color: Colors.brown.shade300.withOpacity(0.6),
                          ),
                          child: SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Center(
                                child: Image.asset(
                                  'assets/teacher.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      const Text(
                        "선생님",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              isTeacher: false,
                              showLoginWithEmail: true,
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          height: MediaQuery.sizeOf(context).width / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(128),
                            ),
                            color: Colors.brown.shade300.withOpacity(0.6),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/study.png',
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      const Text(
                        "학부모",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
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
