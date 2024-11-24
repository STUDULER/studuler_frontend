import 'package:flutter/material.dart';

import '../../common/http/http_service.dart';
import '../../common/util/gesture_dectector_hiding_keyboard.dart.dart';
import '../../common/widget/background.dart';
import '../widget/add_class_input_tile/class_name_input_tile.dart';
import '../widget/add_class_input_tile/class_price_input_tile.dart';
import '../widget/add_class_input_tile/class_schedule_input_tile.dart';
import '../widget/add_class_input_tile/class_start_date_input_tile.dart';
import '../widget/add_class_input_tile/class_theme_color_input_tile.dart';
import '../widget/add_class_input_tile/hours_per_class_input_tile.dart';
import '../widget/add_class_input_tile/how_to_pay_input_tile.dart';
import '../widget/add_class_input_tile/number_of_classes_to_pay_input_tile.dart';
import '../widget/add_class_input_tile/student_name_input_tile.dart';
import '../widget/add_class_tile.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final HttpService httpService = HttpService();

  int currIndex = 0;
  TextEditingController classNameController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController numOfClassesToPayController = TextEditingController();
  TextEditingController classPriceController = TextEditingController();
  TextEditingController classScheduleController = TextEditingController();
  TextEditingController classStartDateController = TextEditingController();
  TextEditingController hoursPerClassController = TextEditingController();
  TextEditingController howToPayController = TextEditingController();
  TextEditingController themeColorController = TextEditingController();

  @override
  void dispose() {
    classNameController.dispose();
    studentNameController.dispose();
    numOfClassesToPayController.dispose();
    classPriceController.dispose();
    classScheduleController.dispose();
    classStartDateController.dispose();
    hoursPerClassController.dispose();
    howToPayController.dispose();
    themeColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var beforeButton = GestureDectectorHidingKeyboard(
      onTap: () {
        setState(() {
          currIndex--;
        });
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("이전"),
        ),
      ),
    );

    var nextButton = GestureDectectorHidingKeyboard(
      onTap: () {
        setState(() {
          currIndex++;
        });
      },
      child: Container(
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("다음"),
        ),
      ),
    );

    var submitButton = GestureDectectorHidingKeyboard(
      onTap: () async {
        if (classNameController.text.isEmpty) return;
        if (studentNameController.text.isEmpty) return;
        if (numOfClassesToPayController.text.isEmpty) return;
        if (classPriceController.text.isEmpty) return;
        if (classScheduleController.text.isEmpty) return;
        if (classStartDateController.text.isEmpty) return;
        if (hoursPerClassController.text.isEmpty) return;
        if (howToPayController.text.isEmpty) return;
        if (themeColorController.text.isEmpty) return;

        final String? classId = await httpService.createClass(
          className: classNameController.text,
          numOfClassesToPay: numOfClassesToPayController.text,
          classPrice: classPriceController.text,
          classSchedule: classScheduleController.text,
          hoursPerClass: hoursPerClassController.text,
          howToPay: howToPayController.text,
          themeColor: themeColorController.text,
        );
        if (classId != null && classId.isNotEmpty) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Container(
        width: 102,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC7B7A3),
        ),
        child: const Center(
          child: Text("추가하기"),
        ),
      ),
    );

    void howToPayControllerUpdate(String text) {
      setState(() {
        howToPayController.text = text;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDectectorHidingKeyboard(
          child: Stack(
            children: [
              const Background(
                iconActionButtons: [],
              ),
              Column(
                children: [
                  const SizedBox(height: 120),
                  const Text(
                    "수업 추가하기",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(64),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 0,
                            height: 80,
                            title: "수업이름",
                            inputTile: ClassNameInputTile(
                              currIndex: currIndex,
                              positionIndex: 0,
                              classNameController: classNameController,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 1,
                            height: 80,
                            title: "학생이름",
                            inputTile: StudentNameInputTile(
                              currIndex: currIndex,
                              positionIndex: 1,
                              studentNameController: classNameController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 2,
                            height: 80,
                            title: "수업료 납부 횟수",
                            inputTile: NumberOfClassesToPayInputTile(
                              currIndex: currIndex,
                              positionIndex: 2,
                              classNameController: numOfClassesToPayController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 3,
                            height: 80,
                            title: "수업료",
                            inputTile: ClassPriceInputTile(
                              currIndex: currIndex,
                              positionIndex: 3,
                              classNameController: classPriceController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 4,
                            height: 120,
                            title: "수업 일정",
                            inputTile: ClassScheduleInputTile(
                              currIndex: currIndex,
                              positionIndex: 4,
                              classScheduleController: classScheduleController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 5,
                            height: 80,
                            title: "수업 시작일",
                            inputTile: ClassStartDateInputTile(
                              currIndex: currIndex,
                              positionIndex: 5,
                              classStartDateController: classStartDateController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 6,
                            height: 80,
                            title: "회당 시간",
                            inputTile: HoursPerClassInputTile(
                              currIndex: currIndex,
                              positionIndex: 6,
                              hoursPerClassController: hoursPerClassController,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 7,
                            height: 80,
                            title: "납부 방식",
                            inputTile: HowToPayInputTile(
                              currIndex: currIndex,
                              positionIndex: 7,
                              onPressed: howToPayControllerUpdate,
                              beforeButton: beforeButton,
                              nextButton: nextButton,
                            ),
                          ),
                          AddClassTile(
                            currIdx: currIndex,
                            positionIdx: 8,
                            height: 120,
                            title: "테마 색상 설정",
                            inputTile: ClassThemeColorInputTile(
                              currIndex: currIndex,
                              positionIndex: 8,
                              themeColorController: themeColorController,
                              beforeButton: beforeButton,
                              nextButton: submitButton,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
