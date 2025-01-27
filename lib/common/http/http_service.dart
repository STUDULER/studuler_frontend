import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';
import 'package:studuler/main.dart';
import 'package:studuler/teacher/model/account_info.dart';

import '../auth/auth_service.dart';
import '../model/class_settlement.dart';
import '../model/last_settlement.dart';
import '../model/next_settlment.dart';
import '../model/class_day.dart';
import '../model/class_feedback.dart';
import '../page/role_selection_page.dart';
import '../section/class_info_item.dart';

class HttpService {
  final Dio call = Dio();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  HttpService._privateConstructor() {
    call.options.baseUrl = "http://13.209.171.206:8443";
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
          print(error);
          // if (error.response?.statusCode == 302) {
          //   // 302 Redirection
          //   debugPrint("302 Response");
          // }
          // final prevJwt = await _secureStorage.read(key: "jwt");
          final prevRefreshToken =
              await _secureStorage.read(key: "refreshToken");
          final prevCookie = await _secureStorage.read(key: "cookie");
          if (error.response?.statusCode == 403) {
            if (error.response?.data == "Need refresh token") {
              // access token expiration error
              try {
                final response = await call.post(
                  '/refreshAccessToken',
                  options: Options(
                    headers: {
                      'cookie': prevCookie,
                    },
                  ),
                );
                final tokenMap = _parseJwtAndRefreshToken(
                  response: response,
                  isJwtInBody: false,
                  withUserId: false,
                );
                await _saveLoginData(
                  map: tokenMap,
                  isTeacher: null,
                );

                final clonedRequest = await call.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                return handler.resolve(clonedRequest);
              } catch (e) {
                AuthService().signOut();
                final context = navigatorKey.currentContext;
                if (context != null) {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectionPage(),
                      ),
                    );
                  }
                }
                return handler.reject(error);
              }
            }
          }

          if (error.response?.statusCode == 405) {
            print("405");
            // Handle 405 Unauthorized error
            try {
              // Attempt to refresh the token

              // Update the authorization header with the new token
              error.requestOptions.headers['Authorization'] =
                  'Bearer $prevRefreshToken';

              // Retry the request with the new token
              final clonedRequest = await call.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(clonedRequest);
            } catch (e) {
              AuthService().signOut();
              final context = navigatorKey.currentContext;
              if (context != null) {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionPage(),
                    ),
                  );
                }
              }
              return handler.reject(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> autoLogin() async {
    try {
      final prevCookie = await _secureStorage.read(key: "cookie");
      final response = await call.post(
        '/refreshAccessToken',
        options: Options(
          headers: {
            'cookie': prevCookie,
          },
        ),
      );
      final tokenMap = _parseJwtAndRefreshToken(
        response: response,
        isJwtInBody: false,
        withUserId: false,
      );
      await _saveLoginData(
        map: tokenMap,
        isTeacher: null,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool?> loginWithMail({
    required bool isTeacher,
    required String mail,
    required String password,
  }) async {
    try {
      // FCM 토큰 가져오기
      String? fcmToken;
      if (Platform.isAndroid) {
        final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        fcmToken = await firebaseMessaging.getToken();
      }

      String path = isTeacher ? "/teachers" : "/students";
      String fcmKey = isTeacher ? 'teacherFCM' : 'studentFCM';
      final response = await call.post(
        "$path/loginWithMail",
        data: {
          'mail': mail,
          "password": password,
          fcmKey: fcmToken,
        },
      );
      Map<String, String> tokenMap = _parseJwtAndRefreshToken(
        response: response,
        isJwtInBody: true,
        withUserId: true,
      );
      _saveLoginData(
        map: tokenMap,
        isTeacher: isTeacher,
      );
    } on DioException catch (e) {
      if (e.response?.data['message'] == "잘못된 메일 입니다. 다시 입력해주세요.") {
        return null;
      }
      if (e.response?.data['message'] == "잘못된 비밀번호 입니다. 다시 입력해주세요.") {
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> isAlreadyOAuthUser({
    required String id,
    required bool isTeacher,
    required int loginMethod,
    String username = '',
  }) async {
    Response? response;
    try {
      String? fcmToken;
      // FCM 토큰 가져오기
      if (Platform.isAndroid) {
        final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        fcmToken = await firebaseMessaging.getToken();
      }
      String path = isTeacher ? "/teachers" : "/students";
      String fcmKey = isTeacher ? 'teacherFCM' : 'studentFCM';
      if (loginMethod == 1) {
        response = await call.post(
          "$path/loginWithKaKao",
          data: {
            'kakaoId': id,
            'username': username,
            fcmKey: fcmToken,
          },
        );
      } else if (loginMethod == 2) {
        response = await call.post(
          "$path/loginWithGoogle",
          data: {
            'mail': id,
            'username': username,
            fcmKey: fcmToken,
          },
        );
      } else {
        // TODO - EMAIL
      }
    } catch (e) {
      return false;
    }
    if (response == null) return false;
    final tokenMap = _parseJwtAndRefreshToken(
      response: response,
      isJwtInBody: true,
      withUserId: true,
    );
    await _saveLoginData(
      map: tokenMap,
      isTeacher: isTeacher,
    );
    return true;
  }

  Future<void> quitMember() async {
    if (await _isTeacher()) {
      await call.post('/teachers/signout');
    } else {
      await call.post('/students/signout');
    }
  }

  Future<bool> createTeacher({
    required OAuthUserDto dto,
    required String bank,
    required String account,
    required String name,
    required int loginMethod,
    required String? kakaoId,
    required String? kakaoQrUrl,
  }) async {
    final Response response;
    if (loginMethod == 1) {
      response = await call.post(
        "/teachers/signup",
        data: {
          "username": dto.username,
          "password": dto.password,
          "account": int.parse(account),
          "bank": bank,
          "name": name,
          "mail": "",
          "loginMethod": loginMethod,
          "image": dto.image,
          "kakaoId": dto.mail,
          "kakaopayLink": kakaoQrUrl,
        },
      );
    } else if (loginMethod == 2) {
      response = await call.post(
        "/teachers/signup",
        data: {
          "username": dto.username,
          "password": dto.password,
          "account": int.parse(account),
          "bank": bank,
          "name": name,
          "mail": dto.mail,
          "loginMethod": loginMethod,
          "image": dto.image,
          "kakaopayLink": kakaoQrUrl,
        },
      );
    } else {
      response = await call.post(
        "/teachers/signup",
        data: {
          "username": dto.username,
          "password": dto.password,
          "account": int.parse(account),
          "bank": bank,
          "name": name,
          "mail": dto.mail,
          "loginMethod": loginMethod,
          "image": dto.image,
          "kakaopayLink": kakaoQrUrl,
        },
      );
    }
    if (response.statusCode != 201) {
      return false;
    }
    final tokenMap = _parseJwtAndRefreshToken(
      response: response,
      isJwtInBody: true,
      withUserId: true,
    );

    await _saveLoginData(map: tokenMap, isTeacher: true);
    return true;
  }

  Future<bool> createParent({
    required OAuthUserDto dto,
    required int loginMethod,
  }) async {
    try {
      final Response response;
      if (loginMethod == 1) {
        response = await call.post(
          "/students/loginWithKakao",
          data: {
            'username': dto.username,
            'kakaoId': dto.mail,
          },
        );
      } else if (loginMethod == 2) {
        response = await call.post(
          "/students/loginWithGoogle",
          data: {
            "username": dto.username,
            "mail": dto.mail,
          },
        );
      } else {
        response = await call.post(
          "/students/signup",
          data: {
            "username": dto.username,
            "password": dto.password,
            "mail": dto.mail,
            "loginMethod": loginMethod,
            "image": dto.image,
          },
        );
      }
      final tokenMap = _parseJwtAndRefreshToken(
        response: response,
        isJwtInBody: true,
        withUserId: true,
      );
      await _saveLoginData(map: tokenMap, isTeacher: false);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> checkMail({
    required String mail,
    required bool isTeacher,
  }) async {
    if (isTeacher) {
      final response = await call.get(
        "/teachers/checkMail",
        data: {
          "mail": mail,
        },
      );
      return response.data;
    } else {
      final response = await call.get(
        "/students/checkMail",
        data: {
          "mail": mail,
        },
      );
      return response.data;
    }
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
    String? fcmToken;

    if (Platform.isAndroid) {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      fcmToken = await firebaseMessaging.getToken();
    }

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
        "teacherFCM": fcmToken, // FCM 토큰
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

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        if (data.isEmpty) {
          throw Exception("No classes available for the teacher.");
        }
        return data.map((classInfo) {
          // 색상 매핑
          int colorIndex = classInfo['themecolor'] ?? -1;
          Color mappedColor =
              (colorIndex >= 0 && colorIndex < colorPalette.length)
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
            'finishedLessons': classInfo['finished_lessons'],
            'period': classInfo['period'],
            'themeColor': mappedColor, // 매핑된 색상
            'infoItems': [
              ClassInfoItem(
                icon: Icons.person,
                title: '학생 이름',
                value: classInfo['studentname'] ?? '정보 없음',
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
                value: classInfo['prepay'] == 1 ? '선불' : '후불',
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
                title: '이번 회차 정산일',
                value: classInfo['dateofpayment'] != null
                    ? DateTime.parse(classInfo['dateofpayment'])
                            .toLocal()
                            .toString()
                            .split(' ')[
                        0] // '2025-01-13T00:00:00.000Z' -> '2025-01-13'
                    : '정보 없음',
              ),
            ],
          };
        }).toList();
      } else if (response.statusCode == 404) {
        throw Exception("API endpoint not found.");
      } else {
        throw Exception(
            "Failed to fetch classes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error in fetchClasses: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchClassesStudent() async {
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
      final response = await call.get('/home/eachClassS');

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        if (data.isEmpty) {
          throw Exception("No classes available for the student.");
        }
        return data.map((classInfo) {
          // 색상 매핑
          int colorIndex = classInfo['themecolor'] ?? -1;
          Color mappedColor =
              (colorIndex >= 0 && colorIndex < colorPalette.length)
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
            'finishedLessons': classInfo['finished_lessons'],
            'period': classInfo['period'],
            'themeColor': mappedColor, // 매핑된 색상
            'infoItems': [
              ClassInfoItem(
                icon: Icons.person,
                title: '선생님 이름',
                value: classInfo['teachername'] ?? '정보 없음',
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
                title: '이번 회차 정산일',
                value: classInfo['dateofpayment'] != null
                    ? DateTime.parse(classInfo['dateofpayment'])
                            .toLocal()
                            .toString()
                            .split(' ')[
                        0] // '2025-01-13T00:00:00.000Z' -> '2025-01-13'
                    : '정보 없음',
              ),
            ],
          };
        }).toList();
      } else if (response.statusCode == 404) {
        throw Exception("API endpoint not found.");
      } else {
        throw Exception(
            "Failed to fetch classes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error in fetchClassesStudent: $e');
      rethrow;
    }
  }

  Future<bool> updateStudentName({
    required int classId,
    required String studentName,
  }) async {
    try {
      print("Preparing request...");
      print("classId type: ${classId.runtimeType}, value: $classId");
      print(
          "studentName type: ${studentName.runtimeType}, value: $studentName");
      final response = await call.put(
        "/home/updateStudentNameT",
        data: {
          // body로 데이터 전송
          "classId": classId,
          "studentname": studentName,
        },
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateStudentName: $e");
      rethrow; // 예외를 다시 던져 디버깅에 활용
    }
  }

  Future<bool> updateClassName({
    required int classId,
    required String className,
  }) async {
    try {
      final response = await call.put(
        "/home/updateClassNameT",
        data: {"classId": classId, "classname": className},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateClassName: $e");
      return false;
    }
  }

  Future<bool> updateDay({
    required int classId,
    required String day,
  }) async {
    try {
      final response = await call.put(
        "/home/updateDayT",
        data: {"classId": classId, "day": day},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateDay: $e");
      return false;
    }
  }

  Future<bool> updateTime({
    required int classId,
    required int time,
  }) async {
    try {
      final response = await call.put(
        "/home/updateTimeT",
        data: {"classId": classId, "time": time},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateTime: $e");
      return false;
    }
  }

  Future<bool> updatePeriod({
    required int classId,
    required int period,
  }) async {
    try {
      final response = await call.put(
        "/home/updatePeriodT",
        data: {"classId": classId, "period": period},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updatePeriod: $e");
      return false;
    }
  }

  Future<bool> updateHourlyRate({
    required int classId,
    required int hourlyRate,
  }) async {
    try {
      final response = await call.put(
        "/home/updateHourlyRateT",
        data: {"classId": classId, "hourlyrate": hourlyRate},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateHourlyRate: $e");
      return false;
    }
  }

  Future<bool> updatePrepay({
    required int classId,
    required int prepay,
  }) async {
    try {
      final response = await call.put(
        "/home/updatePrepayT",
        data: {"classId": classId, "prepay": prepay},
      );
      // 백엔드 메시지 출력
      print("Response message: ${response.data['message']}");

      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updatePrepay: $e");
      return false;
    }
  }

  Future<bool> updateThemeColor({
    required int classId,
    required int themeColor,
  }) async {
    try {
      final response = await call.put(
        "/home/updateThemeColorT",
        data: {"classId": classId, "themecolor": themeColor},
      );
      return response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.';
    } catch (e) {
      print("Error in updateThemeColor: $e");
      return false;
    }
  }

  Future<bool> updateTeacherNameS({
    required int classId,
    required String teacherName,
  }) async {
    try {
      final response = await call.put(
        "/home/updateTeacherNameS",
        data: {
          "classId": classId,
          "teachername": teacherName,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error in updateTeacherNameS: $e");
      return false;
    }
  }

  Future<bool> updateClassNameS({
    required int classId,
    required String className,
  }) async {
    try {
      final response = await call.put(
        "/home/updateClassNameS",
        data: {
          "classId": classId,
          "classname": className,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error in updateClassNameS: \$e");
      return false;
    }
  }

  Future<bool> updateThemeColorS({
    required int classId,
    required int themeColor,
  }) async {
    try {
      final response = await call.put(
        "/home/updateThemeColorS",
        data: {
          "classId": classId,
          "themecolor": themeColor,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error in updateThemeColorS: \$e");
      return false;
    }
  }

  Future<bool> deleteClass(int classId) async {
    try {
      final response = await call.delete('/home/removeClass', data: {
        "classId": classId,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<DateTime>> fetchIncompleteFeedbackDates({
    required int classId,
  }) async {
    try {
      // 오늘 날짜를 YYYY-MM-DD 형식으로 포맷
      final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      debugPrint(
          'Requesting incomplete feedback dates with: classId=$classId, fromDate=$todayDate');

      final response = await call.get('/home/noFeedback', queryParameters: {
        "classId": classId,
        "fromDate": todayDate, // 오늘 날짜를 fromDate로 설정
      });

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        debugPrint('Response data: $data');
        return data.map((item) {
          return DateTime.parse(item['date']);
        }).toList();
      } else {
        throw Exception("Failed to fetch incomplete feedback dates.");
      }
    } catch (e) {
      debugPrint("Error in fetchIncompleteFeedbackDates: $e");
      throw Exception("Error in fetchIncompleteFeedbackDates: $e");
    }
  }

  Future<List<ClassDay>> fetchCalendarForMonth({
    required int year,
    required int month,
  }) async {
    try {
      final response = await call.get(
        "/total/calendarT",
        queryParameters: {"year": year, "month": month},
      );

      if (response.statusCode == 200) {
        final List data = response.data;

        return data.map((item) {
          return ClassDay(
            classId: item['classid'],
            day: Jiffy.parse(item['date'], pattern: 'yyyy-MM-dd'),
            isPayDay: item['dateofpayment'] != null,
            colorIdx: item['themecolor'] ?? -1,
          );
        }).toList();
      } else {
        throw Exception("Failed to fetch calendar data.");
      }
    } catch (e) {
      throw Exception("Error in fetchCalendarForMonth: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchClassesByDate(String date) async {
    final response = await _isTeacher()
        ? await call.get(
            '/total/classByDateT',
            queryParameters: {'date': date},
          )
        : await call.get(
            '/total/classByDateS',
            queryParameters: {'date': date},
          );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to fetch classes by date');
    }
  }

  Future<int?> createClassFeedback({
    required int classId,
    required DateTime date,
    required String did,
    required String attitude,
    required String homework,
    required String memo,
    required int rating,
  }) async {
    int? homeworkParam;
    switch (homework) {
      case "미완료":
        homeworkParam = 0;
        break;
      case "부분완료":
        homeworkParam = 1;
        break;
      case "완료":
        homeworkParam = 2;
        break;
      default:
        break;
    }

    final result = await call.post(
      "/each/createFeedback",
      data: {
        "classid": classId,
        "date": _jiffyToFormat(Jiffy.parseFromDateTime(date)),
        "workdone": did.isEmpty ? null : did,
        "attitude": attitude.isEmpty ? null : attitude,
        "homework": homeworkParam,
        "memo": memo.isEmpty ? null : memo,
        "rate": rating,
      },
    );
    if (result.statusCode != 201) return null;
    return result.data['feedbackId'];
  }

  Future<int?> updateClassFeedback({
    required int feedbackId,
    required String did,
    required String attitude,
    required String homework,
    required String memo,
    required int rating,
  }) async {
    int? homeworkParam;
    switch (homework) {
      case "미완료":
        homeworkParam = 0;
        break;
      case "부분완료":
        homeworkParam = 1;
        break;
      case "완료":
        homeworkParam = 2;
        break;
      default:
        break;
    }

    final result = await call.put(
      "/each/editFeedback",
      data: {
        "feedbackId": feedbackId,
        "workdone": did.isEmpty ? null : did,
        "attitude": attitude.isEmpty ? null : attitude,
        "homework": homeworkParam,
        "memo": memo.isEmpty ? null : memo,
        "rate": rating,
      },
    );
    if (result.statusCode != 200) return null;
    return result.data['feedbackId'];
  }

  Future<List<ClassDay>> fetchClassScheduleOFMonth({
    required int classId,
    required Jiffy date,
  }) async {
    try {
      final queryParameters = {
        "year": date.year,
        "month": date.month,
      };

      // GET 요청
      final response = await _isTeacher()
          ? await call.get(
              "/total/calendarT",
              queryParameters: queryParameters,
            )
          : await call.get(
              "/total/calendarS",
              queryParameters: queryParameters,
            );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // 응답 데이터 처리 및 변환
        return data.map((item) {
          return ClassDay(
            classId: item['classid'],
            day: Jiffy.parse(item['date'], pattern: 'yyyy-MM-dd'),
            isPayDay: item['dateofpayment'] != null,
            colorIdx: item['themecolor'] ?? -1,
          );
        }).toList();
      } else {
        throw Exception("Failed to fetch class schedule.");
      }
    } catch (e) {
      return [];
      // rethrow;
    }
  }

  Future<List<ClassDay>> fetchClassSchedulePerPageOFMonth({
    required int classId,
    required Jiffy date,
  }) async {
    await Future.delayed(Durations.long1); // 달력 바뀌는 거 기다리는 시간
    List<ClassDay> rst = [];
    String path = '/each/calendar';
    if (await _isTeacher()) {
      path = "${path}T";
    } else {
      path = "${path}S";
    }
    try {
      final response = await call.get(
        path,
        data: {
          "classId": classId,
          "year": date.year,
          "month": date.month,
        },
      );
      for (var data in response.data) {
        final classDay = ClassDay(
          classId: classId,
          day: Jiffy.parse(data['date']),
          isPayDay: data['date'] == data['dateofpayment'],
          colorIdx: data['themecolor'],
        );
        rst.add(classDay);
      }
      return rst;
    } catch (e) {
      return [];
    }
  }

  Future<ClassFeedback?> fetchClassFeedback({
    required int classId,
    required Jiffy date,
  }) async {
    String path = '/each/feedbackByDate';
    if (await _isTeacher()) {
      path = '${path}T';
    } else {
      path = '${path}S';
    }
    final response = await call.get(
      path,
      data: {
        'classId': classId,
        'date': _jiffyToFormat(date),
      },
    );
    final data = response.data as List;
    if (data.isEmpty) return null;
    final feedback = data.first;
    if (feedback['feedbackid'] == null) return null;
    return ClassFeedback(
      feedbackId: feedback['feedbackid'],
      date: Jiffy.parse(feedback['date']).dateTime,
      workdone: feedback['workdone'] ?? "",
      attitude: feedback['attitude'] ?? "",
      homework: feedback['homework'],
      memo: feedback['memo'] ?? "",
      rate: int.parse(feedback['rate'].toString()),
    );
  }

  Future<bool> deleteClassDay({
    required int classId,
    required Jiffy date,
  }) async {
    if (date.isBefore(Jiffy.now(), unit: Unit.day)) return false;
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
    final validationResponse = await call.get(
      '/each/prevLastDate',
      data: {
        "classId": classId,
      },
    );
    if (validationResponse.data['lastDateOfPrevious'] != null &&
        date.isSameOrBefore(
          Jiffy.parse(validationResponse.data['lastDateOfPrevious']),
          unit: Unit.day,
        )) {
      return false;
    }
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

  Future<List<ClassSettlement>> fetchClassSettlements() async {
    String classIdPath = '/home/classId';
    String unpaidClassPath = '/payment/unpaid';

    if (await _isTeacher()) {
      classIdPath = "${classIdPath}T";
      unpaidClassPath = "${unpaidClassPath}T";
    } else {
      classIdPath = "${classIdPath}S";
      unpaidClassPath = "${unpaidClassPath}S";
    }

    final response = await call.get(classIdPath);
    if ((response.data as List).isEmpty) return [];
    final paymentResponse = await call.get(unpaidClassPath);
    final List<ClassSettlement> classSettlement = [];

    for (var classData in response.data) {
      var paymentData = paymentResponse.data["${classData['classid']}"];
      List<LastSettlement> lastSettlements = [];
      if (paymentData['unpaid'] == false) {
        if (paymentData['dates'] != null) {
          lastSettlements.add(
            LastSettlement(
              date: Jiffy.parse(paymentData['dates']['date']),
              price: paymentData['dates']['cost'],
              isPaid: true,
            ),
          );
        }
      } else {
        List paymentDates = paymentData['dates'] as List;
        for (var paymentDate in paymentDates) {
          lastSettlements.add(
            LastSettlement(
              date: Jiffy.parse(paymentDate['date']),
              price: paymentDate['cost'],
              isPaid: false,
            ),
          );
        }
      }
      final nextPaymentResponse = await call.get(
        "/payment/nextpayment",
        data: {
          "classId": classData['classid'],
        },
      );
      bool isUnpaid = false;
      if (nextPaymentResponse.data['nextPayment']['unpay'] == 1) {
        isUnpaid = true;
      }
      final nextSettlment = NextSettlment(
        date: Jiffy.parse(nextPaymentResponse.data['nextPayment']['date']),
        price: nextPaymentResponse.data['nextPayment']['cost'],
        isUnpaid: isUnpaid,
      );
      classSettlement.add(
        ClassSettlement(
          classId: classData['classid'],
          className: classData['classname'],
          classColor: classData['themecolor'],
          lastSettlements: lastSettlements,
          nextSettlment: nextSettlment,
        ),
      );
    }

    return classSettlement;
    // return [
    //   ClassSettlement(
    //     classId: 12,
    //     className: "대치동 수학과외",
    //     classColor: 1,
    //     lastSettlements: [],
    //     nextSettlment:
    //         NextSettlment(date: Jiffy.now(), price: 100, isUnpaid: false),
    //   ),
    //   ClassSettlement(
    //     classId: 12,
    //     className: "대애애애",
    //     classColor: 1,
    //     lastSettlements: [
    //       LastSettlement(date: Jiffy.now(), price: 11000, isPaid: true),
    //       LastSettlement(date: Jiffy.now(), price: 11000, isPaid: false),
    //     ],
    //     nextSettlment:
    //         NextSettlment(date: Jiffy.now(), price: 1223, isUnpaid: true),
    //   ),
    // ];
  }

  Future<bool> updateClassAsPaid({
    required int classId,
    required Jiffy paidDate,
  }) async {
    final response = await call.put(
      '/payment/updateAsPaid',
      data: {
        'classId': classId,
        'paidDate': _jiffyToFormat(paidDate),
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) return true;
    return false;
  }

  Future<Map<String, String>> fetchPaymentInfo({
    required int classId,
  }) async {
    final response = await call.get(
      "/payment/paymentInfo",
      data: {
        "classId": classId,
      },
    );
    final Map<String, String> resultMap = {};
    resultMap['name'] = response.data['name'] ?? "";
    resultMap['account'] = response.data['account'] ?? "";
    resultMap['bank'] = response.data['bank'] ?? "";
    return resultMap;
  }

  Future<String> getName() async {
    if (await _isTeacher()) {
      final response = await call.get("/teachers/name");
      return response.data[0]['username'];
    } else {
      final response = await call.get("/students/name");
      return response.data[0]['username'];
    }
  }

  Future<AccountInfo> getAccountInfo() async {
    final response = await call.get("/home/accountInfo");
    return AccountInfo(
      account: response.data[0]['account'],
      name: response.data[0]['name'],
      bank: response.data[0]['bank'],
      kakaopayLink: response.data[0]['kakaopayLink'],
    );
  }

  Future<void> updateAccountInfo({
    required AccountInfo accountInfo,
  }) async {
    await call.put(
      "/home/updateAccountInfo",
      data: {
        "name": accountInfo.name,
        "account": accountInfo.account,
        "bank": accountInfo.bank,
        "kakaopayLink": accountInfo.kakaopayLink,
      },
    );
  }

  Future<String?> getKakaopayLink({
    required int classId,
  }) async {
    final response = await call.get(
      '/payment/kakaopayLink',
      data: {
        'classId': classId,
      },
    );
    return response.data['kakaopayLink'] != ""
        ? response.data['kakaopayLink']
        : null;
  }

  Future<bool> _isTeacher() async {
    return await AuthService().isTeacher();
  }

  Future<bool> isTeacher() async {
    return await _isTeacher();
  }

  String _jiffyToFormat(Jiffy date) {
    return date.format(
      pattern: 'yyyy-M-dd',
    );
  }

  Map<String, String> _parseJwtAndRefreshToken({
    required Response response,
    required bool isJwtInBody,
    required bool withUserId,
  }) {
    final Map<String, String> resultMap = {};
    final Map<String, String> cookieMap = {};
    var cookiesFormatted = '';
    response.headers.forEach(
      (name, values) {
        if (name == HttpHeaders.setCookieHeader) {
          for (var c in values) {
            var key = '';
            var value = '';

            key = c.substring(0, c.indexOf('='));
            value = c.substring(key.length + 1, c.indexOf(';'));

            cookieMap[key] = value;
          }

          cookieMap
              .forEach((key, value) => cookiesFormatted += '$key=$value; ');
          return;
        }
      },
    );
    if (withUserId) resultMap['userId'] = "${response.data['userId']}";
    resultMap['jwt'] = isJwtInBody
        ? response.data['accessToken']
        : (response.headers['authorization'] as List<String>)
            .first
            .split(" ")[1];
    resultMap['refreshToken'] = cookieMap['refreshToken'] ?? "";
    resultMap['cookie'] = cookiesFormatted;
    return resultMap;
  }

  Future<void> _saveLoginData({
    required Map<String, String> map,
    required bool? isTeacher,
  }) async {
    await _secureStorage.write(key: 'userId', value: map['userId']);
    if (isTeacher != null) {
      await _secureStorage.write(
        key: 'role',
        value: isTeacher ? "teacher" : "student",
      );
    }
    await _secureStorage.write(key: 'jwt', value: map['jwt']);
    await _secureStorage.write(key: 'refreshToken', value: map['refreshToken']);
    await _secureStorage.write(key: 'cookie', value: map['cookie']);
  }

  Future<String?> joinClass({required String classCode}) async {
    String? fcmToken;
    if (Platform.isAndroid) {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      fcmToken = await firebaseMessaging.getToken();
    }

    try {
      // PUT 요청 보내기
      final response = await call.put(
        '/home/joinClass',
        data: {
          "classcode": classCode, // 요청에 classcode 포함
          "studentFCM": fcmToken,
        },
      );

      // 응답 성공 시 메시지 반환
      if (response.statusCode == 200) {
        return response.data['classname'] ?? "Successfully joined the class.";
      } else {
        // 상태 코드가 200이 아닐 경우 에러 메시지 반환
        return "Failed to join the class. Status code: ${response.statusCode}";
      }
    } catch (e) {
      // 요청 중 오류가 발생한 경우
      print("Error in joinClass: $e");
      return "An error occurred while joining the class.";
    }
  }

  Future<String?> fetchStudentFCMByClassId(int classId) async {
    try {
      final response = await call.get(
        "/payment/studentFCMByTeacher",
        data: {
          "classId": classId,
        },
      );

      if (response.statusCode == 200) {
        return response.data['studentFCM']; // 서버에서 반환된 FCM 토큰
      } else {
        throw Exception(
          "Failed to fetch FCM token. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error in fetchStudentFCMByClassId: $e");
      return null;
    }
  }

  Future<String?> fetchTeacherFCMByClassId(int classId) async {
    try {
      final response = await call.get(
        "/payment/teacherFCMByStudent",
        data: {
          "classId": classId,
        },
      );

      if (response.statusCode == 200) {
        return response.data['teacherFCM']; // 서버에서 반환된 FCM 토큰
      } else {
        throw Exception(
            "Failed to fetch Teacher FCM token. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchTeacherFCMByClassId: $e");
      return null;
    }
  }

  Future<bool> sendNotification(
      String fcmToken, String title, String body) async {
    const String serviceAccountKeyPath =
        "lib/common/auth/studuler.json"; // 서비스 계정 키 경로

    try {
      // 서비스 계정 키 로드
      final String serviceAccount =
          await rootBundle.loadString(serviceAccountKeyPath);
      final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

      // OAuth 2.0 인증 클라이언트 생성
      final client = await clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      // HTTP v1 API URL
      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/studuler/messages:send',
      );

      // 메시지 페이로드
      final payload = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
          },
        },
      };

      // 요청 전송
      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(payload),
      );

      // 응답 상태 확인
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error in sendNotification: $e");
      return false;
    }
  }
}
