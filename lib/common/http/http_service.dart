import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:studuler/common/auth/oauth_user_dto.dart';

import '../model/class_settlement.dart';
import '../model/last_settlement.dart';
import '../model/next_settlment.dart';
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

  Future<bool> createParent(OAuthUserDto dto, int loginMethod) async {
    final response = await call.post(
      "/students/signup",
      data: {
        "username": dto.username,
        "password": dto.password,
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
            'finishedLessons':classInfo['finished_lessons'],
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

  Future<bool> updateStudentName({
    required int classId,
    required String studentName,
  }) async {
    try {
      print("학생 이름 업데이트 요청 시작: classId=$classId, studentName=$studentName");

      // PUT 요청 보내기
      final response = await call.put(
        "/home/updateStudentNameT", // 엔드포인트
        data: {
          "classid": classId, // 서버가 요구하는 키와 값
          "studentname": studentName,
        }, // 요청 데이터
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print("응답 성공: ${response.data}");
        if (response.data['message'] == 'Class information updated successfully.') {
          print("학생 이름 업데이트 성공");
          return true;
        } else {
          print("서버에서 실패 메시지 반환: ${response.data['message']}");
          return false;
        }
      } else {
        print("응답 실패: 상태 코드=${response.statusCode}, 응답 데이터=${response.data}");
        return false;
      }
    } catch (e) {
      print("학생 이름 업데이트 중 오류 발생: $e");
      return false;
    }
  }

  Future<bool> updateClassName({
    required int classId,
    required String className,
  }) async {
    return _putRequest(
      endpoint: "/home/updateClassNameT",
      data: {"classid": classId, "classname": className},
    );
  }

  Future<bool> updateDay({
    required int classId,
    required String day,
  }) async {
    return _putRequest(
      endpoint: "/home/updateDayT",
      data: {"classid": classId, "day": day},
    );
  }

  Future<bool> updateTime({
    required int classId,
    required int time,
  }) async {
    return _putRequest(
      endpoint: "/home/updateTimeT",
      data: {"classid": classId, "time": time},
    );
  }

  Future<bool> updatePeriod({
    required int classId,
    required int period,
  }) async {
    return _putRequest(
      endpoint: "/home/updatePeriodT",
      data: {"classid": classId, "period": period},
    );
  }

  Future<bool> updateHourlyRate({
    required int classId,
    required int hourlyRate,
  }) async {
    return _putRequest(
      endpoint: "/home/updateHourlyRateT",
      data: {"classid": classId, "hourlyrate": hourlyRate},
    );
  }

  Future<bool> updatePrepay({
    required int classId,
    required int prepay,
  }) async {
    return _putRequest(
      endpoint: "/home/updatePrepayT",
      data: {"classid": classId, "prepay": prepay},
    );
  }

  Future<bool> updateThemeColor({
    required int classId,
    required int themeColor,
  }) async {
    return _putRequest(
      endpoint: "/home/updateThemeColorT",
      data: {"classid": classId, "themecolor": themeColor},
    );
  }

  Future<bool> _putRequest({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    print("API 호출 시작: $endpoint");
    print("요청 데이터: $data");

    try {
      final response = await call.put(endpoint, data: data);

      print("응답 데이터: ${response.data}");
      if (response.statusCode == 200 &&
          response.data['message'] == 'Class information updated successfully.') {
        print("API 호출 성공: $endpoint");
        return true;
      } else {
        print("API 호출 실패: 응답 메시지 = ${response.data['message']}");
        return false;
      }
    } catch (e) {
      print("API 호출 중 오류 발생: $e");
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
      debugPrint('Requesting incomplete feedback dates with: classId=$classId, fromDate=$todayDate');

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
    final response = await call.get(
      '/total/classByDateT',
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
    int homeworkParam = 0;
    switch (homework) {
      case "미완료":
        homeworkParam = 0;
        break;
      case "부분완료":
        homeworkParam = 1;
        break;
      case "완료":
      default:
        homeworkParam = 2;
        break;
    }

    final result = await call.post(
      "/each/createFeedback",
      data: {
        "classid": classId,
        "date": _jiffyToFormat(Jiffy.parseFromDateTime(date)),
        "workdone": did,
        "attitude": attitude,
        "homework": homeworkParam,
        "memo": memo,
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
    int homeworkParam = 0;
    switch (homework) {
      case "미완료":
        homeworkParam = 0;
        break;
      case "부분완료":
        homeworkParam = 1;
        break;
      case "완료":
      default:
        homeworkParam = 2;
        break;
    }

    final result = await call.put(
      "/each/editFeedback",
      data: {
        "feedbackId": feedbackId,
        "workdone": did,
        "attitude": attitude,
        "homework": homeworkParam,
        "memo": memo,
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
      final response = await call.get(
        "/total/calendarT",
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
      rethrow;
    }
  }

  Future<List<ClassDay>> fetchClassSchedulePerPageOFMonth({
    required int classId,
    required Jiffy date,
  }) async {
    await Future.delayed(Durations.long1);
    List<ClassDay> rst = [];
    try {
      final response = await call.get(
        "/each/calendarT",
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
    final response = await call.get(
      '/each/feedbackByDateT',
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
      workdone: feedback['workdone'],
      attitude: feedback['attitude'],
      homework: feedback['homework'],
      memo: feedback['memo'],
      rate: int.parse(feedback['rate'].toString()),
    );
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

  Future<List<ClassSettlement>> fetchClassSettlements() async {
    // TMP
    await Future.delayed(Durations.medium2);
    return [
      ClassSettlement(
        classId: 11,
        className: '대치동 수학 학원',
        classColor: 1,
        lastSettlements: [
          LastSettlement(
            date: Jiffy.now(),
            price: 112302,
            isPaid: true,
          ),
          LastSettlement(
            date: Jiffy.now(),
            price: 1102,
            isPaid: true,
          ),
          LastSettlement(
            date: Jiffy.now(),
            price: 112301232332,
            isPaid: false,
          ),
        ],
        nextSettlment: NextSettlment(
          date: Jiffy.now(),
        ),
      ),
      ClassSettlement(
        classId: 12,
        className: '성수동 국어 학원',
        classColor: 7,
        lastSettlements: [
          LastSettlement(
            date: Jiffy.now(),
            price: 1102,
            isPaid: true,
          ),
        ],
        nextSettlment: NextSettlment(
          date: Jiffy.now(),
        ),
      ),
    ];
  }

  String _jiffyToFormat(Jiffy date) {
    return date.format(
      pattern: 'yyyy-M-dd',
    );
  }
}
