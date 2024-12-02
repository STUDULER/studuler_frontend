import 'package:jiffy/jiffy.dart';

class ClassDay {
  final int classId;
  final Jiffy day;
  final bool isPayDay;
  final int colorIdx;

  ClassDay({
    required this.classId,
    required this.day,
    required this.isPayDay,
    required this.colorIdx,
  });
}
