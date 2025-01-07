import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/http/http_service.dart';
import '../../common/widget/background.dart';
import '../../main.dart';
import '../section/student_settlement_class_section.dart';

class StudentSettlementPage extends StatefulWidget {
  const StudentSettlementPage({super.key});

  @override
  State<StudentSettlementPage> createState() => _StudentSettlementPageState();
}

class _StudentSettlementPageState extends State<StudentSettlementPage> {
final HttpService httpService = HttpService();
  final List<StudentSettlementClassSection> settlementClassSections = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initSettlementClassSections();
  }

  Future<void> _initSettlementClassSections() async {
    setState(() {
      isLoading = true;
    });
    final classSettlements = await httpService.fetchClassSettlements();
    for (var classSettlemnt in classSettlements) {
      settlementClassSections.add(
        StudentSettlementClassSection(
          classSettlement: classSettlemnt,
          rebuild: _initSettlementClassSections,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            isTeacher: false,
            iconActionButtons: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => mainScaffoldKey.currentState?.openEndDrawer(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 100,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(64),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32.0,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "정산현황",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                    ), // 아무 것도 없을 때 좌우로 길게 늘리기 위한 목적
                    const Gap(16),
                    isLoading
                        ? const Center(
                            child: Column(
                              children: [
                                Gap(200),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: settlementClassSections,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}