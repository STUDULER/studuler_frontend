import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

import 'auth_service_type.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true,
    ),
  );

  Future<void> signIn({
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
        break;

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
        }
        break;

      default:
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
        await _secureStorage.deleteAll();
        break;
      default:
    }
  }

  Future<bool> autoLogin() async {
    String? isLoggedIn = await _secureStorage.read(key: 'isLoggedIn');

    if (isLoggedIn == 'true') {
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
    } else {
      print('User is not logged in');
      return false;
    }
  }

}
