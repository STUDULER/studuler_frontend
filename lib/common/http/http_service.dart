import 'package:dio/dio.dart';

class HttpService {
  final Dio call = Dio();

  HttpService() {
    call.options.baseUrl = "https://studuler.com";
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    // call.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     final jwt = await localAuthStorage.getJwt();
    //     options.headers['Authorization'] = 'Bearer $jwt';
    //     return handler.next(options);
    //   },
    //   onError: (DioException error, handler) async {
    //     debugPrint(error.message);
    //     if (error.response?.statusCode == 302) {
    //       // 302 Redirection
    //       debugPrint("302 Response");
    //     }
    // if (error.response?.statusCode == 401) {
    //   // Handle 401 Unauthorized error
    //   try {
    //     // Attempt to refresh the token
    //     final newToken = await authRepository.refreshToken();

    //     // Update the authorization header with the new token
    //     error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

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
    // return handler.next(error);
    // },
    // ));
  }
}
