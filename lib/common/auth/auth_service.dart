import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'auth_service_type.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<bool> signIn({
    required AuthServiceType authServiceType,
  }) async {
    switch (authServiceType) {
      case AuthServiceType.google:
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          await _secureStorage.write(key: 'isLoggedIn', value: 'true');
          await _secureStorage.write(
            key: "authServiceType",
            value: "google",
          );
        }
        print(googleUser);
        print("sign in");
        return true;

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
          print(profileInfo.toString());
        } catch (error) {
          print('Kakao sign in failed: $error');
          return false;
        }
        return true;

      default:
    }
    return false;
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
}
