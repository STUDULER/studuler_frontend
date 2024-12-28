import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'role_selection_page.dart';

class DrawerPage extends StatelessWidget {
  DrawerPage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width / 5 * 3,
      child: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          Container(
            width: MediaQuery.sizeOf(context).width / 3,
            height: MediaQuery.sizeOf(context).width / 3,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade200,
              borderRadius: BorderRadius.circular(128),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "선생님이름",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("설정"),
            onTap: () {
              print("설정");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("로그아웃"),
            onTap: () {
              _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoleSelectionPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
