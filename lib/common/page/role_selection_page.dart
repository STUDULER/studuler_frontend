import 'package:flutter/material.dart';

import '../section/yellow_background.dart';
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
              Text(
                "STUDULER",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Text("당신의 역할을 선택해주세요"),
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
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          height: MediaQuery.sizeOf(context).width / 2.5,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(128)),
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const Text("선생님"),
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
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          height: MediaQuery.sizeOf(context).width / 2.5,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(128)),
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const Text("학부모"),
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
