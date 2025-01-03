import 'last_settlement.dart';
import 'next_settlment.dart';

class ClassSettlement {
  final int classId;
  final String className;
  final int classColor;
  final List<LastSettlement> lastSettlements;
  final NextSettlment nextSettlment;

  ClassSettlement({
    required this.classId,
    required this.className,
    required this.classColor,
    required this.lastSettlements,
    required this.nextSettlment,
  });
}
