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
    NotificationListenerService().onNotification = _handleNotification;
  }

  void _handleNotification(Map<String, dynamic> n) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final isPaused = (n['title']?.toString().toUpperCase().contains('PAUSED') ?? false);

      setState(() {
        _currentNotification = n;
        _hasPause = isPaused;
      });

      _updatePauseState();
    });
  }

  void _updatePauseState() {
    final receivedAt = _currentNotification?['_receivedAt'] as DateTime?;

    if (_hasPause && _pauseStartTime == null && receivedAt != null) {
      _startPauseTimer(receivedAt);
      return;
    }

    if (!_hasPause && _pauseStartTime != null) {
      _stopPauseTimer();
    }
  }

  void _startPauseTimer(DateTime startTime) {
    _pauseStartTime = startTime;
    _pauseTimer?.cancel();

    _pauseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _elapsedPauseTime = DateTime.now().difference(_pauseStartTime!);
          });
        }
      });
    });
  }

  void _stopPauseTimer() {
    _pauseTimer?.cancel();
    _pauseStartTime = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _elapsedPauseTime = Duration.zero);
      }
    });
  }

  void _startNextPauseCountdown() {
    _nextPauseTimer?.cancel();

    _nextPauseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _timeUntilNextPause = _timeUntilNextPause.inSeconds > 0
                ? _timeUntilNextPause - const Duration(seconds: 1)
                : const Duration(seconds: 30);
          });
        }
      });
    });
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF1A2332),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A3A4A), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildPauseContent()),
                  const SizedBox(width: 10),
                  Card(
                    color: _hasPause ? const Color(0x664CAF50) : const Color(0x66F44336),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.pause_circle_outline,
                          color: _hasPause ? Colors.green : Colors.red),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Active Pause',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Next Pause in:', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(
              _formatDuration(_timeUntilNextPause),
              style: const TextStyle(color: Color(0xFF2B7FFF), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPauseContent() {
    if (!_hasPause) {
      return const Text(
        'You have not initiated an active pause. Start an active pause to allow monitoring.',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('You have an active pause in progress',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 10),
        _buildInfoRow('Last active pause:', '20:30:00', 'Next active pause:', '22:30:00'),
        const SizedBox(height: 10),
        const Text(
          'Current active pause',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInfoRow('Started at:', '21:30:00', 'Finish at:', '21:45:00'),
        const SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              const Text('Time in pause:',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                _formatDuration(_elapsedPauseTime),
                style: const TextStyle(
                    color: Color(0xFF20C997), fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String l1, String v1, String l2, String v2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn(l1, v1),
        _buildInfoColumn(l2, v2),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
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
