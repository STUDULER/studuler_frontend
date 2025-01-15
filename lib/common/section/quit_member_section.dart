import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../auth/auth_service.dart';
import '../http/http_service.dart';
import '../page/role_selection_page.dart';

class QuitMemberSection extends StatefulWidget {
  const QuitMemberSection({super.key});

  @override
  State<QuitMemberSection> createState() => _QuitMemberSectionState();
}

class _QuitMemberSectionState extends State<QuitMemberSection> {
  final TextEditingController _controller = TextEditingController();
  bool validationError = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey.shade400,
    );
    return Column(
      children: [
        Text(
          "탈퇴 시 해당 계정의 정보가 모두 삭제됩니다.",
          style: textStyle,
        ),
        Text(
          "탈퇴를 원하실 경우 '탈퇴'를 입력해주세요.",
          style: textStyle,
        ),
        TextField(
          controller: _controller,
        ),
        if (validationError)
          Text(
            "'탈퇴'를 입력해주세요",
            style: textStyle.copyWith(
              color: Colors.red,
            ),
          ),
        Gap(28),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 48,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFC7B7A3).withOpacity(
                    0.34,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "취소",
                    style: TextStyle(
                      color: Color(0xFFC7B7A3),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(8),
            GestureDetector(
              onTap: () async {
                if (_controller.text != "탈퇴") {
                  setState(() {
                    validationError = true;
                  });
                  return;
                }
                await HttpService().quitMember();
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionPage(),
                    ),
                  );
                }
              },
              child: Container(
                width: 48,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFC7B7A3),
                ),
                child: const Center(
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(4),
        Text(
          "'확인' 클릭 시 해당 동작은 되돌릴 수 없습니다",
          style: textStyle,
        ),
      ],
    );
  }
}
