import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
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

class KaKaoTestPage extends StatelessWidget {
  const KaKaoTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              // final token = await UserApi.instance.loginWithKakaoTalk();

              final token = await UserApi.instance.loginWithNewScopes(
                [
                  "talk_message",
                ],
              );

              print(token.scopes);

              print(token);
              final textTemplate = TextTemplate(
                text: "sodfn",
                link: Link(),
                buttonTitle: "복사하기",
              );
              // TalkApi.instance.
              try {
                await TalkApi.instance.sendDefaultMemo(textTemplate);
                print('나에게 보내기 성공');
              } catch (error) {
                print('나에게 보내기 실패 $error');
              }
            },
            child: Container(
              width: 200,
              height: 100,
              color: Colors.amber,
              child: Center(
                child: Text("나에게 보내기"),
              ),
            ),
          ),
          Gap(20),
          GestureDetector(
            onTap: () async {
              final token = await UserApi.instance.loginWithKakaoTalk();

              var params = PickerFriendRequestParams(
                title: '싱글 피커', // 피커 이름
                enableSearch: true, // 검색 기능 사용 여부
                showFavorite: true, // 즐겨찾기 친구 표시 여부
                enableBackButton:
                    true, // 뒤로 가기 버튼 사용 여부, 리다이렉트 방식 웹 또는 네이티브 앱에서만 사용 가능
              );

              // 피커 호출
              try {
                if (context.mounted) {
                  SelectedUsers users = await PickerApi.instance.selectFriend(
                    params: params,
                    context: context,
                  );
                  print(users.users!.first.uuid);
                  print('친구 선택 성공: ${users.users!.length}');
                }
              } catch (e) {
                print('친구 선택 실패: $e');
              }

              // final token = await UserApi.instance.loginWithNewScopes(["talk_message"]);

              // Friends friends;
              // try {
              //   friends = await TalkApi.instance.friends();
              // } catch (error) {
              //   print('카카오톡 친구 목록 가져오기 실패 $error');
              //   // 메시지를 보낼 수 있는 친구 정보 가져오기에 실패한 경우에 대한 예외 처리 필요
              //   return;
              // }

              // if (friends.elements == null) {
              //   // 메시지를 보낼 수 있는 친구가 없는 경우에 대한 예외 처리 필요
              //   return;
              // }

              // if (friends.elements!.isEmpty) {
              //   print('메시지를 보낼 친구가 없습니다');
              // } else {
              //   print(friends.elements);
              //   // 서비스에 상황에 맞게 메시지 보낼 친구의 UUID를 가져옵니다.
              //   // 이 예제에서는 친구 목록을 화면에 보여주고 체크박스로 선택된 친구들의 UUID를 수집하도록 구현했습니다.
              //   if (context.mounted) {
              //     // List<String> selectedItems = await Navigator.of(context).push(
              //     //   MaterialPageRoute(
              //     //     builder: (context) => FriendPage(
              //     //       items: friends.elements!
              //     //           .map((friend) => PickerItem(
              //     //               friend.uuid,
              //     //               friend.profileNickname ?? '',
              //     //               friend.profileThumbnailImage))
              //     //           .toList(),
              //     //     ),
              //     //   ),
              //     // );
              //     // if (selectedItems.isEmpty) {
              //     //   // 메시지를 보낼 친구를 선택하지 않은 경우에 대한 예외 처리 필요
              //     //   return;
              //     // }
              //     // print('선택된 친구:\n${selectedItems.join('\n')}');

              //     // // 메시지를 보낼 친구의 UUID 목록
              //     // List<String> receiverUuids = selectedItems;

              //     // final textTemplate = TextTemplate(
              //     //   text: "sodfn",
              //     //   link: Link(),
              //     //   buttonTitle: "복사하기",
              //     // );

              //     // // 기본 템플릿으로 메시지 보내기
              //     // try {
              //     //   MessageSendResult result =
              //     //       await TalkApi.instance.sendDefaultMessage(
              //     //     receiverUuids: receiverUuids,
              //     //     template: textTemplate,
              //     //   );
              //     //   print('메시지 보내기 성공 ${result.successfulReceiverUuids}');

              //     //   if (result.failureInfos != null) {
              //     //     print('일부 대상에게 메시지 보내기 실패'
              //     //         '\n${result.failureInfos}');
              //     //   }
              //     // } catch (error) {
              //     //   print('메시지 보내기 실패 $error');
              //     // }
              //   }
              // }
            },
            child: Container(
              width: 200,
              height: 100,
              color: Colors.amber,
              child: Center(child: Text("보낼 사람 선택")),
            ),
          ),
          Gap(20),
          GestureDetector(
            onTap: () async {
              bool isKakaoTalkSharingAvailable =
                  await ShareClient.instance.isKakaoTalkSharingAvailable();

              if (isKakaoTalkSharingAvailable) {
                try {
                  final textTemplate = TextTemplate(
                    text: "sodfn",
                    link: Link(),
                    buttonTitle: "복사하기",
                  );

                  Uri uri = await ShareClient.instance
                      .shareDefault(template: textTemplate);
                  await ShareClient.instance.launchKakaoTalk(uri);
                  print('카카오톡 공유 완료');
                } catch (error) {
                  print('카카오톡 공유 실패 $error');
                }
              }
            },
            child: Container(
              width: 200,
              height: 100,
              color: Colors.amber,
              child: Center(child: Text("고ㅇ유")),
            ),
          ),
        ],
      ),
    );
  }
}
