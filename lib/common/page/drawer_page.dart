import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../http/http_service.dart';
import '../section/quit_member_section.dart';
import '../widget/show_studuler_dialog.dart';
import 'role_selection_page.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final AuthService _authService = AuthService();
  final HttpService _httpService = HttpService();
  String name = "";

  @override
  void initState() {
    super.initState();
    initName();
  }

  Future<void> initName() async {
    name = await _httpService.getName();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width / 5 * 3,
      backgroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
            onTap: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleSelectionPage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.waving_hand_rounded,
              color: Colors.grey.shade400,
            ),
            title: Text(
              "회원탈퇴",
              style: TextStyle(color: Colors.grey.shade400),
            ),
            onTap: () async {
              await showStudulerDialog(
                context,
                "정말 탈퇴 하시겠습니까?",
                QuitMemberSection(),
                () {},
                height: 280,
                showButton: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
