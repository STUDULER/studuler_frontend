import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../section/yellow_background.dart';
import '../widget/app_title.dart';

class KakaoPayQrInstructionPage extends StatefulWidget {
  const KakaoPayQrInstructionPage({super.key});

  @override
  State<KakaoPayQrInstructionPage> createState() =>
      _KakaoPayQrInstructionPageState();
}

class _KakaoPayQrInstructionPageState extends State<KakaoPayQrInstructionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YellowBackground(
        child: Column(
          children: [
            const Spacer(
                    flex: 1,
                  ),
            Row(
              children: [
                Gap(12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_new_outlined, size: 16,),
                        Gap(4),
                        Text("뒤로 가기"),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            AppTitle(),
            Gap(10),
            Text("카카오페이 송금 QR 링크 발급 가이드"),
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      index += 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 38.0),
                        child: Image.asset(
                          "assets/kakao_qr_inst_$index.png",
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                    itemCount: 4,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.black,
                        color: Colors.grey.shade400
                      )
                    ),
                    control: SwiperControl(),
                    loop: false,
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
