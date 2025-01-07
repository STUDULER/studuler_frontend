import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/http/http_service.dart';
import '../../common/widget/background.dart';
import '../../main.dart';
import '../section/teacher_settlement_class_section.dart';

class TeacherSettlementPage extends StatefulWidget {
  const TeacherSettlementPage({super.key});

  @override
  State<TeacherSettlementPage> createState() => _TeacherSettlementPageState();
}

class _TeacherSettlementPageState extends State<TeacherSettlementPage> {
  final HttpService httpService = HttpService();
  final List<TeacherSettlementClassSection> settlementClassSections = [];
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
    settlementClassSections.clear();
    final classSettlements = await httpService.fetchClassSettlements();
    for (var classSettlemnt in classSettlements) {
      settlementClassSections.add(
        TeacherSettlementClassSection(
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
