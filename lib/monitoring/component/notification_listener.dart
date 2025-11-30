import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ergovision/shared/services/user_service.dart';

class NotificationListenerService {
  static final NotificationListenerService _instance = NotificationListenerService._internal();
  StompClient? _client;
  Function(Map<String, dynamic>)? onNotification;

  final ValueNotifier<Map<String, dynamic>?> latestNotification = ValueNotifier(null);
  int? _currentUserId;

  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  bool get isConnected => _client?.connected ?? false;

  Future<void> connect(String token) async {
    if (isConnected) return;

    try {
      final response = await UserService().getUserProfile();
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        _currentUserId = user['id'];
      }
    } catch (_) {
      _currentUserId = null;
    }

    _client = StompClient(
      config: StompConfig(
        url: "ws://10.0.2.2:8080/ws-notifications",
        onConnect: _onConnect,
      ),
    );

    _client?.activate();
  }

  void _onConnect(StompFrame frame) {
    _client?.subscribe(
      destination: "/topic/notifications",
      callback: (frame) {
        if (frame.body == null) return;
        try {
          _handleIncomingNotification(json.decode(frame.body!));
        } catch (_) {}
      },
    );
  }

  void _handleIncomingNotification(Map<String, dynamic> data) {
    final notifUserId = data['userId'];
    if (_currentUserId == null || notifUserId != _currentUserId) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      latestNotification.value = {...data, '_receivedAt': DateTime.now()};
    });

    onNotification?.call(data);
  }

  void send(Map<String, dynamic> notif) {
    if (isConnected) {
      _client?.send(destination: "/app/notify", body: jsonEncode(notif));
    }
  }

  void disconnect() {
    if (isConnected) _client?.deactivate();
  }
}

class NotificationListenerWidget extends StatefulWidget {
  const NotificationListenerWidget({super.key});

  @override
  State<NotificationListenerWidget> createState() => _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState extends State<NotificationListenerWidget> {
  Map<String, dynamic>? _current;
  int _pausesTaken = 0;
  DateTime? _pauseStartTime;
  late final ValueNotifier<Duration> _pauseDuration;

  @override
  void initState() {
    super.initState();
    _pauseDuration = ValueNotifier(Duration.zero);
    NotificationListenerService().onNotification = _handleNotification;
  }

  void _handleNotification(Map<String, dynamic> data) {
    final title = (data['title']?.toString() ?? '').toUpperCase();

    if (title.contains('PAUSED')) {
      _pausesTaken++;
      _pauseStartTime = DateTime.now();
      _startPauseTimer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _current = {...data, '_receivedAt': DateTime.now()};
      });
    });
  }

  void _startPauseTimer() {
    if (_pauseStartTime == null) return;

    Future.doWhile(() async {
      if (!mounted || _pauseStartTime == null) return false;

      await Future.delayed(const Duration(seconds: 1));
      _pauseDuration.value = DateTime.now().difference(_pauseStartTime!);
      return true;
    });
  }

  String _buildSnackText(Map<String, dynamic> n) {
    final title = n['title']?.toString() ?? '';
    final msg = n['message']?.toString() ?? '';
    return title.isNotEmpty ? "$title: $msg" : msg;
  }

  _NotifColors _resolveColors(Map<String, dynamic> n) {
    final t = (n['title']?.toString() ?? '').toUpperCase();

    if (t.contains('ACTIVE')) {
      return _NotifColors(
        bg: const Color(0xFF0F2A1F),
        border: const Color(0xFF20C997),
        accent: const Color(0xFF20C997),
        backgroundSnack: const Color(0xFF1E664E),
      );
    }

    if (t.contains('PAUSED')) {
      return _NotifColors(
        bg: const Color(0xFF2A1F10),
        border: const Color(0xFFFFC107),
        accent: const Color(0xFFFFC107),
        backgroundSnack: const Color(0xFF7A5A14),
      );
    }

    return _NotifColors(
      bg: const Color(0xFF1A2332),
      border: const Color(0xFF2A3A4A),
      accent: const Color(0xFF2B7FFF),
      backgroundSnack: const Color(0xFF2B7FFF),
    );
  }

  IconData _resolveIcon(Map<String, dynamic> n) {
    final t = (n['title']?.toString() ?? '').toUpperCase();
    if (t.contains('ACTIVE')) return Icons.play_arrow_rounded;
    if (t.contains('PAUSED')) return Icons.pause_circle_filled_rounded;
    return Icons.notifications;
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: const Color(0xFF2A3A4A).withOpacity(0.7), width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A2332), const Color(0xFF232B3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: _current == null
            ? Row(
                children: [
                  Icon(Icons.notifications_none, color: Colors.white24, size: 32),
                  const SizedBox(width: 12),
                  const Text("Waiting for notification...", style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              )
            : _buildNotificationCard(_current!),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final colors = _resolveColors(n);
    final time = n['_receivedAt'] is DateTime ? _formatTime(n['_receivedAt']) : '--:--:--';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.accent.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(_resolveIcon(n), color: colors.accent, size: 36),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                n['title']?.toString() ?? 'Notification',
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
              ),
              if ((n['message']?.toString() ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    n['message'] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
              if ((n['title']?.toString() ?? '').toUpperCase().contains('PAUSED')) ...[
                ValueListenableBuilder<Duration>(
                  valueListenable: _pauseDuration,
                  builder: (context, duration, _) {
                    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
                    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Pause Time: $minutes:$seconds",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "Pauses Taken: $_pausesTaken",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pauseDuration.dispose();
    NotificationListenerService().onNotification = null;
    super.dispose();
  }
}

class _NotifColors {
  final Color bg, border, accent, backgroundSnack;
  _NotifColors({required this.bg, required this.border, required this.accent, required this.backgroundSnack});
}
