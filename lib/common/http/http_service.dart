import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import '../model/class_day.dart';
import '../model/class_feedback.dart';

class HttpService {
  final Dio call = Dio();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  HttpService._privateConstructor() {
    call.options.baseUrl = "http://13.209.171.206";
    _initializeInterceptors();
  }
  static final HttpService _instance = HttpService._privateConstructor();

  factory HttpService() {
    return _instance;
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
    required int numOfClassesToPay,
    required int classPrice,
    required String classSchedule,
    required int hoursPerClass,
    required int howToPay,
    required int themeColor,
    required String studentName,
    required String classStartDate,
  }) async {
    final userId = await _secureStorage.read(key: "userId");
    final response = await call.post(
      "/home/createClass",
      data: {
        "classname": className, // 사용자 입력값
        "studentname": studentName, // 사용자 이름
        "startdate": classStartDate, // 시작 날짜
        "period": numOfClassesToPay, // 결제할 수업 개수
        "time": hoursPerClass, // 수업 시간
        "day": classSchedule, // 수업 일정
        "hourlyrate": classPrice, // 수업 가격
        "prepay": howToPay, // 결제 방법
        "themecolor": themeColor, // 테마 색상
        "teacherid": userId, // 유저 아이디
      },
    );
    if (response.statusCode != 201) return null;
    return response.data['classId'].toString();
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
    toggle = !toggle;
    if (toggle) {
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
    } else {
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
      ];
    }
  }

  bool toggle = false;
  Future<ClassFeedback?> fetchClassFeedback({
    required Jiffy date,
  }) async {
    await Future.delayed(Durations.long1);
    if (date.isSame(Jiffy.parse("2024-12-02"), unit: Unit.day)) {
      return ClassFeedback(
        date: date.dateTime,
        workdone: "굳굳굳",
        attitude: "좋은 태도",
        homework: 2,
        memo: "최고임",
        rate: 10,
      );
    } else {
      return null;
    }
    // toggle = !toggle;
    // if (toggle) {
    //   return ClassFeedback(
    //     date: date.dateTime,
    //     workdone: "굳굳굳",
    //     attitude: "좋은 태도",
    //     homework: 2,
    //     memo: "최고임",
    //     rate: 10,
    //   );
    // } else {
    //   return ClassFeedback(
    //     date: date.dateTime,
    //     workdone: "최악 또 최악",
    //     attitude: "이루 말할 수 없는 최악",
    //     homework: 0,
    //     memo: "과외 그만 둘 거",
    //     rate: 0,
    //   );
    // }
  }

  Future<bool> deleteClassDay({
    required int classId,
    required Jiffy date,
  }) async {
    // await Future.delayed(Durations.long1);
    // return true;
    final response = await call.put(
      "/each/deleteLesson",
      data: {
        "classId": classId,
        "dateToDelete": _jiffyToFormat(date),
      },
    );
    if (response.statusCode != 201) return false;
    return true;
  }

  Future<bool> addClassDay({
    required int classId,
    required Jiffy date,
  }) async {
    // await Future.delayed(Durations.long1);
    // return true;
    final response = await call.post(
      "/each/addLesson",
      data: {
        "classId": classId,
        "newDate": _jiffyToFormat(date),
      },
    );
    if (response.statusCode != 201) return false;
    return true;
  }

  String _jiffyToFormat(Jiffy date) {
    return date.format(
      pattern: 'yyyy-M-dd',
    );
  }
}
