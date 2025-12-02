class MothlyProgress {
  final int id;
  final String month;
  final double averageScore;

  MothlyProgress({
    required this.id,
    required this.month,
    required this.averageScore,
  });
  factory MothlyProgress.fromJson(Map<String, dynamic> json) {
    return MothlyProgress(
      id: json['id'],
      month: json['month'],
      averageScore: json['averageScore'].toDouble(),
    );
  }


}