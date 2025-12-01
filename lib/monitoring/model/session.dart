class Session {
  final String id;
  final String startDate;
  final String endDate;
  final double score;
  final double goodScore;
  final double badScore;
  final double goodPostureTime;
  final double badPostureTime;
  final double duration;
  final int numberOfPauses;
  final double averagePauseDuration;

  Session({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.score,
    required this.goodScore,
    required this.badScore,
    required this.goodPostureTime,
    required this.badPostureTime,
    required this.duration,
    required this.numberOfPauses,
    required this.averagePauseDuration,
  });

  /// Crea una instancia de Session desde un JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      goodScore: (json['goodScore'] as num?)?.toDouble() ?? 0.0,
      badScore: (json['badScore'] as num?)?.toDouble() ?? 0.0,
      goodPostureTime: (json['goodPostureTime'] as num?)?.toDouble() ?? 0.0,
      badPostureTime: (json['badPostureTime'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      numberOfPauses: json['numberOfPauses'] as int? ?? 0,
      averagePauseDuration: (json['averagePauseDuration'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convierte la instancia de Session a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'score': score,
      'goodScore': goodScore,
      'badScore': badScore,
      'goodPostureTime': goodPostureTime,
      'badPostureTime': badPostureTime,
      'duration': duration,
      'numberOfPauses': numberOfPauses,
      'averagePauseDuration': averagePauseDuration,
    };
  }
}