import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';
import 'package:studuler/common/http/http_service.dart';

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
          bool isKakaoInstalled = await isKakaoTalkInstalled();
          OAuthToken token = isKakaoInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();

          await _secureStorage.write(key: 'isLoggedIn', value: 'true');
          await _secureStorage.write(
            key: "authServiceType",
            value: "kakao",
          );

          final url = Uri.https('kapi.kakao.com', '/v2/user/me');
          final response = await http.get(
            url,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
            },
          );
          final profileInfo = json.decode(response.body);
          print(profileInfo);
          return OAuthUserDto(
            username: profileInfo['properties']['nickname'],
            password: "",
            mail: profileInfo['id'].toString(),
            image: 1,
          );
        } catch (error) {
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
    String? userId = await _secureStorage.read(key: 'userId');
    if (userId == null) {
      await _secureStorage.deleteAll();
      return false;
    }
    return await HttpService().autoLogin();
  }

  Future<bool> isTeacher() async {
    final role = await _secureStorage.read(key: "role");
    if (role == "teacher") {
      return true;
    }
    return false;
  }
}
