import 'package:flutter/material.dart';

import '../widget/bank_selection_cell.dart';

class BankSelectionPage extends StatefulWidget {
  const BankSelectionPage({
    super.key,
    required TextEditingController textfieldController,
    required TextEditingController bankController,
    required List<String> banks,
  })  : _bankController = bankController,
        _textfieldController = textfieldController,
        _banks = banks;

  final TextEditingController _bankController;
  final TextEditingController _textfieldController;
  final List<String> _banks;

  @override
  State<BankSelectionPage> createState() => _BankSelectionPageState();
}

class _BankSelectionPageState extends State<BankSelectionPage> {
  List<String> _filteredBanks = [];

  // 은행 이름과 로고 매핑
  final Map<String, String> bankLogos = {
    "카카오뱅크": "kakao_bank.png",
    "국민은행": "kb_bank.png",
    "기업은행": "ibk_bank.png",
    "농협은행": "nh_bank.png",
    "신한은행": "shinhan_bank.png",
    "산업은행": "kdb_bank.png",
    "우리은행": "woori_bank.png",
    "한국씨티은행": "citi_bank.png",
    "하나은행": "hana_bank.png",
    "SC제일은행": "sc_bank.png",
    "경남은행": "kyongnam_bank.png",
    "광주은행": "kwangju_bank.png",
    "대구은행": "daegu_bank.png",
    "도이치은행": "deutsche_bank.png",
    "뱅크오브아메리카": "bofa_bank.png",
    "부산은행": "busan_bank.png",
    "신림조합중앙회": "sinrim_bank.png",
    "저축은행": "saving_bank.png",
  };

  @override
  void initState() {
    super.initState();
    _filteredBanks = widget._banks
        .where(
          (item) => item.toLowerCase().contains(
                widget._textfieldController.text.toLowerCase(),
              ),
        )
        .toList();
    widget._textfieldController.addListener(() {
      _filterBanks(widget._textfieldController.text);
    });
  }

  void _filterBanks(String query) {
    try {
      setState(() {
        _filteredBanks = widget._banks
            .where(
              (item) => item.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    } catch (e) {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        expand: false,
        snap: true,
        builder: (_, controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 24,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "은행선택",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: widget._textfieldController,
                  decoration: const InputDecoration(
                    hintText: "은행검색",
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                    ),
                    itemCount: _filteredBanks.length,
                    itemBuilder: (context, index) {
                      return BankSelectionCell(
                        controller: widget._bankController,
                        bank: _filteredBanks.elementAt(index),
                        bankLogos: bankLogos, // 매핑 전달
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
