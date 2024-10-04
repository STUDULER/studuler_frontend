import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print("asd");
              },
              child: Container(
                color: Colors.amber,
                width: 300,
                height: 200,
              ),
            ),
            GestureDetector(
              onTap: () {},
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
