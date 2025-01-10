import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import 'auth_service_type.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<OAuthUserDto?> signIn({
    required AuthServiceType authServiceType,
    required bool role,
  }) async {
    if (role == true) {
      // 선생
      await _secureStorage.write(key: "role", value: "teacher");
    } else {
      // 학생
      await _secureStorage.write(key: "role", value: "student");
    }
    switch (authServiceType) {
      case AuthServiceType.google:
        try {
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) return null;
          await _secureStorage.write(key: 'isLoggedIn', value: 'true');
          await _secureStorage.write(
            key: "authServiceType",
            value: "google",
          );
          print(googleUser);
          print("sign in");
          return OAuthUserDto(
            username: googleUser.displayName ?? "",
            password: "",
            mail: googleUser.email,
            image: 1,
          );
        } catch (e) {
          return null;
        }

      case AuthServiceType.kakao:
        try {
          // 1. 카카오톡 앱 설치 여부 확인 및 로그인 시도
          bool isKakaoInstalled = await isKakaoTalkInstalled();
          OAuthToken token = isKakaoInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();

          // AccessToken 출력
          print('Kakao AccessToken: ${token.accessToken}');

          // 2. 토큰 저장
          await _secureStorage.write(key: 'isLoggedIn', value: 'true');
          await _secureStorage.write(key: "authServiceType", value: "kakao");

          try {
            // 3. 서버에 로그인 요청
            final loginResponse = await http.post(
              Uri.parse('https://yourapi.com/loginWithKakao'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'kakaoAccessToken': token.accessToken}),
            );

            // 4. 서버 응답 처리
            if (loginResponse.statusCode == 200) {
              final loginData = jsonDecode(loginResponse.body);

              if (loginData['isExist'] == true) {
                // 이미 회원가입된 유저
                print('Kakao login success: ${loginData.toString()}');
                return OAuthUserDto(
                  username: loginData['username'] ?? "",
                  password: "",
                  mail: loginData['mail'] ?? "",
                  image: 1,
                );
              } else {
                // 회원가입이 필요한 유저
                print('Kakao user not registered: ${loginData.toString()}');
                return OAuthUserDto(
                  username: loginData['username'] ?? "",
                  password: "",
                  mail: loginData['mail'] ?? "",
                  image: 1,
                );
              }
            } else {
              // 서버 응답 실패
              print('Kakao login API failed. Status: ${loginResponse.statusCode}');
              print('Response body: ${loginResponse.body}');
              return null;
            }
          } catch (httpError) {
            // HTTP 요청 관련 오류 처리
            print('Failed to send Kakao login API request: $httpError');
            return null;
          }
        } catch (authError) {
          // 카카오 로그인 관련 오류 처리
          if (authError is KakaoAuthException) {
            print('KakaoAuthException: ${authError.message}');
          } else if (authError is KakaoClientException) {
            print('KakaoClientException: ${authError.message}');
          } else {
            print('Unexpected error during Kakao login: $authError');
          }
          return null;
        }
    }
  }

  Future<void> signOut() async {
    String? authServiceTypeString = await _secureStorage.read(
      key: "authServiceType",
    );
    if (authServiceTypeString == null) return;

    switch (AuthServiceType.values.byName(authServiceTypeString)) {
      case AuthServiceType.google:
        await GoogleSignIn().signOut();
        break;
      case AuthServiceType.kakao:
      default:
    }
    await _secureStorage.deleteAll();
  }

  Future<bool> autoLogin() async {
    String? isLoggedIn = await _secureStorage.read(key: 'isLoggedIn');

    if (isLoggedIn == 'true') {
      String? authServiceTypeString = await _secureStorage.read(
        key: "authServiceType",
      );
      if (authServiceTypeString == null) return false;

      switch (AuthServiceType.values.byName(authServiceTypeString)) {
        case AuthServiceType.google:
          final GoogleSignInAccount? googleUser =
              await GoogleSignIn().signInSilently();
          if (googleUser != null) {
            // User is auto logged in
            print('Auto logged in: ${googleUser.email}');
            return true;
          } else {
            // Silent sign-in failed, clear the login state
            await _secureStorage.deleteAll();
            print('Auto login failed');
            return false;
          }
        case AuthServiceType.kakao:
          return true;
        default:
          return false;
      }
    } else {
      print('User is not logged in');
      await _secureStorage.deleteAll();
      return false;
    }
  }

  Future<bool> isTeacher() async {
    final role = await _secureStorage.read(key: "role");
    if (role == "teacher") {
      return true;
    }
    return false;
  }
}
