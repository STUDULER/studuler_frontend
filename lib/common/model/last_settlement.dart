import 'package:jiffy/jiffy.dart';

class LastSettlement {
  final Jiffy date;
  final int price;
  final bool isPaid;

  LastSettlement({
    required this.date,
    required this.price,
    required this.isPaid,
  });
}
