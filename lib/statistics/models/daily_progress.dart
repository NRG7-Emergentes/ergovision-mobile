
class DailyProgress {
  final int id;
  final String date;
  final double averageScore;

  DailyProgress({
    required this.id,
    required this.date,
    required this.averageScore,
});

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      id: json['id'],
      date: json['date'],
      averageScore: json['averageScore'].toDouble(),
    );
  }
}