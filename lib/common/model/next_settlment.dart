import 'package:jiffy/jiffy.dart';

class NextSettlment {
  final Jiffy date;
  final bool isUnpaid;

  NextSettlment({
    required this.date,
    required this.isUnpaid,
  });
}
