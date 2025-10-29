import 'package:ergovision/monitoring/model/session.dart';
import 'package:flutter/material.dart';

import '../data/sample_sessions.dart';

class SessionDetail extends StatefulWidget {
  final String sessionId;
  const SessionDetail({super.key, required this.sessionId});

  @override
  State<SessionDetail> createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail> {
  @override
  Widget build(BuildContext context) {
    final Session session = sampleSessions.firstWhere((s) => s.id == widget.sessionId);

    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121720),
        title: Text('Session Details',
        style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                  'Session ID:',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        widget.sessionId,
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Overview:',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              /*
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Started on: ',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SizedBox(
                              child: Card(
                                color: const Color(0xFF121720),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A3A4A),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    formatDateTimeLocal(session.startDate),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Ended on: ',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SizedBox(
                              child: Card(
                                color: const Color(0xFF121720),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A3A4A),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    formatDateTimeLocal(session.endDate),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              */
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Started on: ',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              child: Card(
                                color: const Color(0xFF121720),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A3A4A),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    formatDateTimeLocal(session.startDate),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            const Text(
                              'Ended on: ',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              child: Card(
                                color: const Color(0xFF121720),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A3A4A),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    formatDateTimeLocal(session.endDate),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Session time: ',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            SizedBox(
                              child: Card(
                                color: const Color(0xFF121720),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A3A4A),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    formatDurationMs(session.duration),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posture',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Good Posture',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${session.goodScore.toStringAsFixed(1)}%',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      double widthFactor = (session.goodScore / 100.0);
                                      if (widthFactor.isNaN) widthFactor = 0.0;
                                      if (widthFactor < 0.0) widthFactor = 0.0;
                                      if (widthFactor > 1.0) widthFactor = 1.0;
                                      final percent = widthFactor * 100.0;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: getBgColorByScore(percent),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FractionallySizedBox(
                                                widthFactor: widthFactor,
                                                child: Container(
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: getColorByScore(percent).withAlpha((0.9 * 255).round()),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                   Text(
                                     'Time in Good Posture: ${formatDurationMs(session.goodPostureTime)}',
                                     style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
                                   )
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Bad Posture',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${session.badScore.toStringAsFixed(1)}%',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      double widthFactor = (session.badScore / 100.0);
                                      if (widthFactor.isNaN) widthFactor = 0.0;
                                      if (widthFactor < 0.0) widthFactor = 0.0;
                                      if (widthFactor > 1.0) widthFactor = 1.0;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0x66F44336),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: FractionallySizedBox(
                                                widthFactor: widthFactor,
                                                child: Container(
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                     },
                                   ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Time in Bad Posture: ${formatDurationMs(session.badPostureTime)}',
                                    style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Card(
                          color: const Color(0xFF1A2332),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Score',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircleAvatar(
                                    backgroundColor: getColorByScore(session.score),
                                    child: Text(
                                        '${session.score}'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: const Color(0xFF1A2332),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A3A4A),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pauses',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Card(
                          color: const Color(0xFF2A3A4A),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Number of Pauses: ',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  '${session.numberOfPauses}',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          color: const Color(0xFF2A3A4A),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Average Pause Time: ',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  formatDurationMs(session.averagePauseDuration),
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatDurationMs(double ms) {
  // Convierte milisegundos a un string legible: '1h 15m 30s' o '45m 20s'
  if (ms.isNaN || ms <= 0) return '00:00:00';
  final totalSeconds = (ms / 1000).round();
  final totalMinutes = totalSeconds ~/ 60;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  final seconds = totalSeconds % 60;

  if (hours > 0) {
    if (minutes > 0 && seconds > 0) return '$hours:$minutes:$seconds';
    if (minutes > 0) return '$hours:$minutes:00';
    if (seconds > 0) return '$hours:00:$seconds';
    return '$hours:00:00';
  }
  if (minutes > 0) {
    if (seconds > 0) return '00:$minutes:$seconds';
    return '00:$minutes:00';
  }
  return '00:00:$seconds';
}

String formatDateTimeLocal(String date) {
  DateTime? parsedDate;
  try {
    final sd = date;
    if (sd.isNotEmpty) {
      parsedDate = DateTime.parse(sd).toLocal();
    }
  } catch (_) {
    parsedDate = null;
  }

  if (parsedDate == null) {
    return 'Unknown date';
  } else {
    // Formatea como DD/MM/YYYY HH:MM (hora local)
    final local = parsedDate.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}

Color getColorByScore(double score) {
  if (score >= 0 && score <= 30) {
    return Colors.red;
  } else if (score >= 31 && score <= 70) {
    return Colors.yellow;
  } else if (score >= 71 && score <= 100) {
    return Colors.green;
  } else {
    throw ArgumentError('Score fuera de rango (debe estar entre 0 y 100)');
  }
}

Color getBgColorByScore(double score) {
  if (score >= 0 && score <= 30) {
    return Color(0x66F44336);
  } else if (score >= 31 && score <= 70) {
    return Color(0x66FFEB3B);
  } else if (score >= 71 && score <= 100) {
    return Color(0x664CAF50);
  } else {
    throw ArgumentError('Score fuera de rango (debe estar entre 0 y 100)');
  }
}