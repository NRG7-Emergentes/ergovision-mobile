class SessionDetail {
  final String id;
  final String date;
  final String duration;
  final PostureData posture;
  final PauseData pauses;

  SessionDetail({
    required this.id,
    required this.date,
    required this.duration,
    required this.posture,
    required this.pauses,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      id: json['id'].toString(),
      date: json['date'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      posture: PostureData.fromJson(json['posture'] ?? {}),
      pauses: PauseData.fromJson(json['pauses'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'duration': duration,
      'posture': posture.toJson(),
      'pauses': pauses.toJson(),
    };
  }
}

class PostureData {
  final int goodPercent;
  final int badPercent;
  final String goodTime;
  final String badTime;

  PostureData({
    required this.goodPercent,
    required this.badPercent,
    required this.goodTime,
    required this.badTime,
  });

  factory PostureData.fromJson(Map<String, dynamic> json) {
    return PostureData(
      goodPercent: json['goodPercent'] as int? ?? 0,
      badPercent: json['badPercent'] as int? ?? 0,
      goodTime: json['goodTime'] as String? ?? '00:00:00',
      badTime: json['badTime'] as String? ?? '00:00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goodPercent': goodPercent,
      'badPercent': badPercent,
      'goodTime': goodTime,
      'badTime': badTime,
    };
  }
}

class PauseData {
  final int count;
  final String avgTime;
  final String totalTime;

  PauseData({
    required this.count,
    required this.avgTime,
    required this.totalTime,
  });

  factory PauseData.fromJson(Map<String, dynamic> json) {
    return PauseData(
      count: json['count'] as int? ?? 0,
      avgTime: json['avgTime'] as String? ?? '00:00:00',
      totalTime: json['totalTime'] as String? ?? '00:00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'avgTime': avgTime,
      'totalTime': totalTime,
    };
  }
}

