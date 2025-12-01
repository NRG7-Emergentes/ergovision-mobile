import 'package:ergovision/monitoring/bloc/session/session_bloc.dart';
import 'package:ergovision/monitoring/bloc/session/session_event.dart';
import 'package:ergovision/monitoring/bloc/session/session_state.dart';
import 'package:ergovision/monitoring/views/session_detail.dart';
import 'package:ergovision/shared/bloc/user/user_bloc.dart';
import 'package:ergovision/shared/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/session.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  void initState() {
    super.initState();
    // Cargar sesiones cuando se inicializa el widget
    _loadSessions();
  }

  void _loadSessions() {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      context.read<SessionBloc>().add(FetchUserSessionsEvent(userState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, sessionState) {
          return RefreshIndicator(
            onRefresh: () async {
              final userState = context.read<UserBloc>().state;
              if (userState is UserLoaded) {
                context.read<SessionBloc>().add(RefreshSessionsEvent(userState.user.id));
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sessions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'List of past sessions, interact to view more details',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSessionContent(sessionState),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionContent(SessionState state) {
    if (state is SessionLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    if (state is SessionError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadSessions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is SessionsEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 40),
              Icon(Icons.event_busy_outlined, size: 60, color: Colors.white24),
              SizedBox(height: 16),
              Text(
                'No sessions yet',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You have no recorded sessions. Start a new session to see it here.',
                style: TextStyle(color: Colors.white54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state is SessionsLoaded) {
      return _buildSessionCards(context, state.sessions);
    }

    return const SizedBox.shrink();
  }
}

Widget _buildSessionCards(BuildContext context, List<Session> sessions) {
  String formatDateTimeLocal(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day/$month/$year';
  }

  String formatDurationMs(double ms) {
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

  Color getColorByScore(double score) {
    if (score >= 0 && score <= 30) {
      return Colors.red;
    } else if (score >= 31 && score <= 70) {
      return Colors.yellow;
    } else if (score >= 71 && score <= 100) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  return Column(
    children: sessions.map((session) {
      DateTime? parsedDate;
      try {
        final sd = session.startDate;
        if (sd.isNotEmpty) {
          parsedDate = DateTime.parse(sd).toLocal();
        }
      } catch (_) {
        parsedDate = null;
      }

      final String dateLabel = parsedDate != null 
          ? formatDateTimeLocal(parsedDate) 
          : 'Unknown date';

      String durationLabel;
      try {
        durationLabel = formatDurationMs(session.duration);
      } catch (_) {
        durationLabel = '0m';
      }

      final String id = session.id;
      final double score = session.score;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionDetail(sessionId: id),
              ),
            );
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          id,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircleAvatar(
                                backgroundColor: getColorByScore(score),
                                child: Text(
                                  '${score.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Session of $dateLabel',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Duration: $durationLabel',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}