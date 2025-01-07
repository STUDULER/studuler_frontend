import 'package:jiffy/jiffy.dart';

class NextSettlment {
  final Jiffy date;
  final bool isUnpaid;
  final int price;

  NextSettlment({
    required this.date,
    required this.price,
    required this.isUnpaid,
  });
}
