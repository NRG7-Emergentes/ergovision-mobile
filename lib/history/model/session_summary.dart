class SessionSummary {
  final String id;
  final String date;
  final String duration;

  SessionSummary({
    required this.id,
    required this.date,
    required this.duration,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      id: json['id'].toString(),
      date: json['date'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'duration': duration,
    };
  }
}
