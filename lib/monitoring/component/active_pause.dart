import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ergovision/monitoring/component/notification_listener.dart';

class ActivePause extends StatefulWidget {
  const ActivePause({super.key});

  @override
  State<ActivePause> createState() => _ActivePauseState();
}

class _ActivePauseState extends State<ActivePause> {
  Timer? _pauseTimer;
  Timer? _nextPauseTimer;
  Duration _elapsedPauseTime = Duration.zero;
  Duration _timeUntilNextPause = const Duration(seconds: 30);
  DateTime? _pauseStartTime;
  bool _hasPause = false;
  Map<String, dynamic>? _currentNotification;

  @override
  void initState() {
    super.initState();
    _startNextPauseCountdown();
    _setupNotificationListener();
  }

  void _setupNotificationListener() {
    NotificationListenerService().onNotification = _handleNotification;
  }

  void _handleNotification(Map<String, dynamic> notification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentNotification = notification;
          _hasPause = _isPauseNotification(notification);
        });

        _handlePauseStateChange();
      }
    });
  }

  bool _isPauseNotification(Map<String, dynamic> notification) {
    return notification['title']?.toString().toUpperCase().contains('PAUSED') ?? false;
  }

  void _handlePauseStateChange() {
    if (_hasPause && _pauseStartTime == null) {
      final receivedAt = _currentNotification?['_receivedAt'] as DateTime?;
      if (receivedAt != null) {
        _startPauseTimer(receivedAt);
      }
    } else if (!_hasPause && _pauseStartTime != null) {
      _stopPauseTimer();
    }
  }

  void _startPauseTimer(DateTime startTime) {
    _pauseStartTime = startTime;
    _pauseTimer?.cancel();
    _pauseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _elapsedPauseTime = DateTime.now().difference(_pauseStartTime!);
            });
          }
        });
      }
    });
  }

  void _stopPauseTimer() {
    _pauseTimer?.cancel();
    _pauseStartTime = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _elapsedPauseTime = Duration.zero;
        });
      }
    });
  }

  void _startNextPauseCountdown() {
    _nextPauseTimer?.cancel();
    _nextPauseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              if (_timeUntilNextPause.inSeconds > 0) {
                _timeUntilNextPause -= const Duration(seconds: 1);
              } else {
                _timeUntilNextPause = const Duration(seconds: 30);
              }
            });
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Pause',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Next Pause in:',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        _formatDuration(_timeUntilNextPause),
                        style: TextStyle(
                            color: Color(0xFF2B7FFF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _hasPause
                          ? [
                        Text(
                          'You have an active pause in progress',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Last active pause: ',
                                    style: TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                  Text(
                                    '20:30:00',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Next active pause: ',
                                    style: TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                  Text(
                                    '22:30:00',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Current active pause',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Started at:',
                                        style: TextStyle(color: Colors.white70, fontSize: 16),
                                      ),
                                      Text(
                                        '21:30:00',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Finish at:',
                                        style: TextStyle(color: Colors.white70, fontSize: 16),
                                      ),
                                      Text(
                                        '21:45:00',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Time in pause:',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatDuration(_elapsedPauseTime),
                                    style: TextStyle(
                                      color: Color(0xFF20C997),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ]
                          : [
                        Text(
                          'You have not initiated an active pause. Start an active pause to allow the application to monitor your breaks effectively.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                      child: Card(
                        color: _hasPause ? Color(0x664CAF50) : Color(0x66F44336),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.pause_circle_outline, color: _hasPause ? Colors.green : Colors.red),
                        ),
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pauseTimer?.cancel();
    _nextPauseTimer?.cancel();
    NotificationListenerService().onNotification = null;
    super.dispose();
  }
}