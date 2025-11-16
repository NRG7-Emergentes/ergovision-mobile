class Session{
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
    required this.averagePauseDuration
  });
}