import 'package:flutter/material.dart';

import '../model/session.dart';
import '../data/sample_sessions.dart' show sampleSessions;

// Lista de ejemplo de sesiones (ejemplo de datos)
final List<Session> sessions = sampleSessions;

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'Sessions',
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                )
            ),
            const SizedBox(height: 10),
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'List of past sessions, interact to view more details',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                )
            ),
            const SizedBox(height: 10),
            _buildSessionCards(sessions)
          ],
        ),
      ),
    );

  }
}

Widget _buildSessionCards(List<Session> sessions) {

  String formatDateTimeLocal(DateTime dt) {
    // Formatea como DD/MM/YYYY HH:MM (hora local)
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    //final hour = local.hour.toString().padLeft(2, '0');
    //final minute = local.minute.toString().padLeft(2, '0');
    //return '$day/$month/$year $hour:$minute';
    return '$day/$month/$year';
  }

  String formatDurationMs(double ms) {
    // Convierte milisegundos a un string legible: '1h 15m' o '45m'
    if (ms.isNaN || ms <= 0) return '0m';
    final totalSeconds = (ms / 1000).round();
    final totalMinutes = totalSeconds ~/ 60;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      if (minutes > 0) return '${hours}h ${minutes}m';
      return '${hours}h';
    }
    return '${minutes}m';
  }

  // Validación: si la lista está vacía, mostrar un estado vacío amigable
  if (sessions.isEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 40),
          Icon(Icons.event_busy_outlined, size: 60, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You have no recorded sessions. Start a new session to see it here.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  return Column(
    children: sessions.map((session) {
      // Parsear startDate (ISO string) a DateTime y convertir a local
      DateTime? parsedDate;
      try {
        final sd = session.startDate;
        if (sd.isNotEmpty) {
          parsedDate = DateTime.parse(sd).toLocal();
        }
      } catch (_) {
        parsedDate = null;
      }

      final String dateLabel = parsedDate != null ? formatDateTimeLocal(parsedDate) : 'Unknown date';

      // duration está en milisegundos (double). Convertir a texto legible
      String durationLabel;
      try {
        durationLabel = formatDurationMs(session.duration);
      } catch (_) {
        durationLabel = '0m';
      }

      // Título: preferir map de muestras; si no existe usar fallback
      final String id = session.id;

      final int score = session.score.round();

      Color getColorByScore(int score) {
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
      
      return Column(
        children: [
          InkWell(
            onTap: () {
              // Handle session tap (p. ej. navegar a detalle)
            },
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
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            id,
                            style: const TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: CircleAvatar(
                                  backgroundColor: getColorByScore(score),
                                  child: Text(
                                    '$score'
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Session of: $dateLabel',
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Duration • $durationLabel',
                                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                                  ),

                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Colors.white54),
                    ],
                  ),
                ),
              )
            ),
          ),
          SizedBox(height: 10)
        ],
      );
    }).toList(),
  );
}