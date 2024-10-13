import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service_type.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
        print("sign in");
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
