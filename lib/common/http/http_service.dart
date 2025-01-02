import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import '../model/class_day.dart';
import '../model/class_feedback.dart';
import '../section/class_info_item.dart';

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

  Future<List<Map<String, dynamic>>> fetchClasses() async {
    // 색상 팔레트 정의
    const List<Color> colorPalette = [
      Color(0xFFC96868), // Red shade
      Color(0xFFFFBB70), // Peach shade
      Color(0xFFB5C18E), // Green shade
      Color(0xFFCFEFFC), // Light Blue shade
      Color(0xFF5A72A0), // Blue shade
      Color(0xFFDDBCFF), // Lavender shade
      Color(0xFFFCCFCF), // Pink shade
      Color(0xFFD9D9D9), // Light Gray shade
      Color(0xFF545454), // Dark Gray shade
      Color(0xFFB28F65), // Brown shade
    ];

    try {
      final response = await call.get('/home/eachClassT');

      // 응답 데이터 출력 (디버깅용)
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        if (data.isEmpty) {
          throw Exception("No classes available for the teacher.");
        }
        return data.map((classInfo) {
          // 색상 매핑
          int colorIndex = classInfo['themecolor'] ?? -1;
          Color mappedColor = (colorIndex >= 0 && colorIndex < colorPalette.length)
              ? colorPalette[colorIndex]
              : const Color(0xFFFFFFFF); // 기본 색상 (화이트)

          return {
            'classId': classInfo['classid'] ?? 0, // classId 추가
            'title': classInfo['classname'] ?? '제목 없음',
            'code': classInfo['classcode'] ?? '코드 없음',
            'completionRate': classInfo['finished_lessons'] != null &&
                classInfo['period'] != null
                ? classInfo['finished_lessons'] / classInfo['period']
                : 0.0,
            'themeColor': mappedColor, // 매핑된 색상
            'infoItems': [
              ClassInfoItem(
                icon: Icons.person,
                title: '학생 이름',
                value: classInfo['name'] ?? '정보 없음',
              ),
              ClassInfoItem(
                icon: Icons.access_time,
                title: '회당 시간',
                value: '${classInfo['time'] ?? 0}시간',
              ),
              ClassInfoItem(
                icon: Icons.calendar_today,
                title: '요일',
                value: classInfo['day'] ?? '요일 없음',
              ),
              ClassInfoItem(
                icon: Icons.payment,
                title: '정산 방법',
                value: classInfo['prepay'] == true ? '선불' : '후불',
              ),
              ClassInfoItem(
                icon: Icons.attach_money,
                title: '시급',
                value: '${classInfo['hourlyrate'] ?? 0}원',
              ),
              ClassInfoItem(
                icon: Icons.repeat,
                title: '수업 횟수',
                value: '${classInfo['period'] ?? 0}회',
              ),
              ClassInfoItem(
                icon: Icons.calendar_today,
                title: '다음 정산일',
                value: classInfo['dateofpayment'] ?? '정보 없음',
              ),
            ],
          };
        }).toList();
      } else if (response.statusCode == 404) {
        throw Exception("API endpoint not found.");
      } else {
        throw Exception("Failed to fetch classes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error in fetchClasses: $e');
      rethrow;
    }
  }

  Future<bool> deleteClass(int classId) async {
    try {
      final response = await call.delete('/home/deleteClass', data: {
        "classId": classId,
      });

      if (response.statusCode == 200) {
        print("Class deleted successfully");
        return true;
      } else {
        print("Failed to delete class: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in deleteClass: $e");
      return false;
    }
  }

  Future<List<DateTime>> fetchIncompleteFeedbackDates({
    required int classId,
  }) async {
    try {
      final response = await call.get('/home/noFeedback', queryParameters: {
        "classId": classId,
      });

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        return data.map((item) {
          return DateTime.parse(item['date']);
        }).toList();
      } else {
        throw Exception("Failed to fetch incomplete feedback dates.");
      }
    } catch (e) {
      throw Exception("Error in fetchIncompleteFeedbackDates: $e");
    }
  }

  Future<String?> createClassFeedback({
    required int classId,
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
