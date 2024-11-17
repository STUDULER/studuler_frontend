import 'package:dio/dio.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

class HttpService {
  final Dio call = Dio();

  HttpService() {
    call.options.baseUrl = "http://13.209.171.206";
    // call.options.baseUrl = "http://localhost:8080";
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    call.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // final jwt = await localAuthStorage.getJwt();
          const jwt = "43c64c";
          options.headers['Authorization'] = 'Bearer $jwt';
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          print("${error.message}");
          // debugPrint(error.message);
          // if (error.response?.statusCode == 302) {
          //   // 302 Redirection
          //   debugPrint("302 Response");
          // }
          // if (error.response?.statusCode == 401) {
          //   // Handle 401 Unauthorized error
          //   try {
          //     // Attempt to refresh the token
          //     final newToken = await authRepository.refreshToken();

          //     // Update the authorization header with the new token
          //     error.requestOptions.headers['Authorization'] =
          //         'Bearer $newToken';

          //     // Retry the request with the new token
          //     final clonedRequest = await dio.request(
          //       error.requestOptions.path,
          //       options: Options(
          //         method: error.requestOptions.method,
          //         headers: error.requestOptions.headers,
          //       ),
          //       data: error.requestOptions.data,
          //       queryParameters: error.requestOptions.queryParameters,
          //     );
          //     return handler.resolve(clonedRequest);
          //   } catch (e) {
          //     // If token refresh fails, redirect to login or handle accordingly
          //     return handler.reject(error);
          //   }
          // }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> createTeacher(
    OAuthUserDto dto,
    String bank,
    String account,
    int loginMethod,
  ) async {
    final response = await call.post(
      "/teachers/signup",
      data: {
        "username": dto.username,
        "password": dto.password,
        "account": int.parse(account),
        "bank": bank,
        "mail": dto.mail,
        "loginMethod": loginMethod,
        "image": dto.image,
      },
    );
    if (response.statusCode != 201) {
      return false;
    }
    print(response.data);
    return true;
  }

  Future<bool> createParent(String name) async {
    // TMP
    await Future.delayed(const Duration(milliseconds: 300));
    return true;

    // final response = await call.post(
    //   "/api/parents",
    //   data: {
    //     "name": name,
    //   },
    // );
    // if (response.statusCode != 200) {
    //   return false;
    // }
    // return true;
  }

  Future<String?> createClass({
    required String className,
    required String numOfClassesToPay,
    required String classPrice,
    required String classSchedule,
    required String hoursPerClass,
    required String howToPay,
    required String themeColor,
  }) async {
    // TMP
    print("dd");
    await Future.delayed(const Duration(milliseconds: 300));
    return "dummyClassId";

    // final response = await call.post(
    //   "api/class",
    //   data: {
    //     "className": className,
    //     "numOfClassesToPay": numOfClassesToPay,
    //     "classPrice": classPrice,
    //     "classSchedule": classSchedule,
    //     "hoursPerClass": hoursPerClass,
    //     "howToPay": howToPay,
    //     "themeColor": themeColor,
    //   },
    // );
    // if (response.statusCode != 201) return null;
    // return response.data['classId'];
  }
}
