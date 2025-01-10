import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'common/page/splash_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  KakaoSdk.init(
    nativeAppKey: '948e680b2e31563c3d8f21e3881e9450',
  ); // 이 줄을 runApp 위에 추가한다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await requestNotificationPermission();
  runApp(const MyApp());
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Android 13 이상에서 알림 권한 요청
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('알림 권한 허용됨');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('알림 권한 임시 허용됨');
  } else {
    print('알림 권한 거부됨');
  }
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
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
