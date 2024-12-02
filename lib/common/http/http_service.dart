import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import '../model/class_day.dart';

class HttpService {
  final Dio call = Dio();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  HttpService() {
    call.options.baseUrl = "http://13.209.171.206";
    // call.options.baseUrl = "http://localhost:8080";
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    call.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final jwt = await _secureStorage.read(key: "jwt");
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
    String jwt = response.data['token'];
    int userId = response.data['userId'];
    await _secureStorage.write(key: "userId", value: "$userId");
    await _secureStorage.write(key: "jwt", value: jwt);
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
    // print("dd");
    // await Future.delayed(const Duration(milliseconds: 300));
    // return "dummyClassId";
    final userId = await _secureStorage.read(key: "userId");
    // final jwt = await _secureStorage.read(key: "jwt");

    final response = await call.post(
      "/home/createClass",
      data: {
        "classname": "나의 이름은",
        "studnentname": "단한번",
        "startdate": "2020-09-03",
        "period": 10,
        "time": 2,
        "day": "월/화/수",
        "hourlyrate": 15000,
        "prepay": 0,
        "themecolor": 1,
        "teacherid": userId,
      },
    );
    if (response.statusCode != 201) return null;
    // return response.data['classId'];
    return "good";
  }

  Future<List<DateTime>> fetchIncompleteFeedbackDates({
    required String classId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      DateTime.utc(2024, 11, 12),
      DateTime.now(),
    ];
  }

  Future<String?> createClassFeedback({
    required String classId,
    required DateTime date,
    required String did,
    required String attitude,
    required String homework,
    required String memo,
    required int rating,
  }) async {
    // TMP
    await Future.delayed(const Duration(milliseconds: 300));
    return "dummyFeedbackId";

    // final result = await call.post(
    //   "/api/class/feedback",
    //   data: {
    //     "classId": classId,
    //     "date": date,
    //     "did": did,
    //     "attitude": attitude,
    //     "homework": homework,
    //     "memo": memo,
    //     "rating": rating,
    //   },
    // );
    // if (result.statusCode != 201) return null;
    // return result.data['feedbackId'];
  }

  Future<List<ClassDay>> fetchClassScheduleOFMonth({
    required int classId,
    required Jiffy date,
  }) async {
    await Future.delayed(Durations.medium1);
    return [
      ClassDay(
        classId: classId,
        day: Jiffy.parseFromList([date.year, date.month, 2]),
        isPayDay: false,
        colorIdx: 0,
      ),
      ClassDay(
        classId: classId,
        day: Jiffy.parseFromList([date.year, date.month, 9]),
        isPayDay: false,
        colorIdx: 0,
      ),
      ClassDay(
        classId: classId,
        day: Jiffy.parseFromList([date.year, date.month, 16]),
        isPayDay: false,
        colorIdx: 0,
      ),
      ClassDay(
        classId: classId,
        day: Jiffy.parseFromList([date.year, date.month, 23]),
        isPayDay: true,
        colorIdx: 0,
      ),
    ];
  }
}
