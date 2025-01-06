import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'common/page/splash_page.dart';

void main() {
  KakaoSdk.init(
    nativeAppKey: '948e680b2e31563c3d8f21e3881e9450',
  ); // 이 줄을 runApp 위에 추가한다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
