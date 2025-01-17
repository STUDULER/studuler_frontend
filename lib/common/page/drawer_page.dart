import 'package:flutter/material.dart';

import '../../teacher/page/account_management_page.dart';
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
  Widget accountManagementTile = SizedBox.shrink();
  Image? image;

  @override
  void initState() {
    super.initState();
    initBuild();
  }

  Future<void> initBuild() async {
    name = await _httpService.getName();
    if (await _httpService.isTeacher()) {
      accountManagementTile = ListTile(
        leading: const Icon(Icons.account_balance_outlined),
        title: const Text("계좌관리"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountManagementPage(),
            ),
          );
        },
      );
      image = Image.asset(
        'assets/teacher.png',
      );
    } else {
      image = Image.asset(
        'assets/study.png',
      );
    }
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
            child: Center(child: image,),
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
          accountManagementTile,
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
