class MonthlyProgress {
  final int id;
  final String month;
  final double averageScore;

  MonthlyProgress({
    required this.id,
    required this.month,
    required this.averageScore,
  });
  factory MonthlyProgress.fromJson(Map<String, dynamic> json) {
    return MonthlyProgress(
      id: json['id'],
      month: json['month'],
      averageScore: json['averageScore'].toDouble(),
    );
  }


}