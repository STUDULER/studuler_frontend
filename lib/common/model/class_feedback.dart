class ClassFeedback {
  final int? feedbackId;
  final DateTime date;
  final String workdone;
  final String attitude;
  final int? homework;
  final String memo;
  final int rate;

  ClassFeedback({
    this.feedbackId,
    required this.date,
    required this.workdone,
    required this.attitude,
    required this.homework,
    required this.memo,
    required this.rate,
  });
}
