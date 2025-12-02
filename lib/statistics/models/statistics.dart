import 'mothly_progress.dart';
import 'daily_progress.dart';

class Statistics {
  final int id;
  final int userId;
  final List<MonthlyProgress> monthlyProgresses;
  final List<DailyProgress> dailyProgresses;
  final double globalAverageScore;
  final double averageSessionTimeMinutes;
  final double averagePausesPerSession;
  final double totalMonitoredHours;

  Statistics({
    required this.id,
    required this.userId,
    required this.monthlyProgresses,
    required this.dailyProgresses,
    required this.globalAverageScore,
    required this.averageSessionTimeMinutes,
    required this.averagePausesPerSession,
    required this.totalMonitoredHours,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      id: json['id'],
      userId: json['userId'],
      monthlyProgresses: (json['monthlyProgresses'] as List)
          .map((item) => MonthlyProgress.fromJson(item))
          .toList(),
      dailyProgresses: (json['dailyProgresses'] as List)
          .map((item) => DailyProgress.fromJson(item))
          .toList(),
      globalAverageScore: json['globalAverageScore'].toDouble(),
      averageSessionTimeMinutes: json['averageSessionTimeMinutes'].toDouble(),
      averagePausesPerSession: json['averagePausesPerSession'].toDouble(),
      totalMonitoredHours: json['totalMonitoredHours'].toDouble(),
    );
  }
}