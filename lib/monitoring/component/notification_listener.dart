import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ergovision/shared/client/api_client.dart';
import 'package:ergovision/shared/services/user_service.dart';

class NotificationListenerService {
  static final NotificationListenerService _instance = NotificationListenerService._internal();
  StompClient? _client;
  Function(Map<String, dynamic>)? onNotification;

  final ValueNotifier<Map<String, dynamic>?> latestNotification = ValueNotifier(null);
  int? _currentUserId;

  List<Map<String, dynamic>> userNotifications = [];
  bool _notificationsFetched = false;

  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  bool get isConnected => _client?.connected ?? false;

  Future<void> connect(String token) async {
    if (isConnected) return;

    // Obtiene el id del usuario usando UserService
    try {
      final response = await UserService().getUserProfile();
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        _currentUserId = user['id'];
      }
    } catch (_) {
      _currentUserId = null;
    }

    await fetchUserNotifications();

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
    // Solo procesa notificaciones del usuario autenticado
    if (_currentUserId == null || notifUserId != _currentUserId) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      latestNotification.value = {...data, '_receivedAt': DateTime.now()};
      userNotifications.insert(0, {...data, '_receivedAt': DateTime.now()});
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

  Future<void> fetchUserNotifications() async {
    if (_currentUserId == null || _notificationsFetched) return;
    try {
      final response = await ApiClient.get('notifications/user/$_currentUserId');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Filtra notificaciones solo del usuario actual
        userNotifications = data
            .where((n) => n['userId'] == _currentUserId)
            .cast<Map<String, dynamic>>()
            .toList();
        _notificationsFetched = true;
      }
    } catch (_) {}
  }
}

class NotificationListenerWidget extends StatefulWidget {
  const NotificationListenerWidget({super.key});

  @override
  State<NotificationListenerWidget> createState() => _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState extends State<NotificationListenerWidget> {
  Map<String, dynamic>? _current;

  @override
  void initState() {
    super.initState();
    NotificationListenerService().onNotification = _handleNotification;
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    await NotificationListenerService().fetchUserNotifications();
    setState(() {});
  }

  void _handleNotification(Map<String, dynamic> data) {
    final colors = _resolveColors(data);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _current = {...data, '_receivedAt': DateTime.now()};
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_buildSnackText(data)),
          backgroundColor: colors.backgroundSnack,
          duration: const Duration(seconds: 2),
        ),
      );
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
    // Elimina historial, solo muestra la notificación en tiempo real
    return Card(
      color: const Color(0xFF1A2332),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF2A3A4A), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Live Notification",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _current == null
                ? const Text("Waiting for notification...", style: TextStyle(color: Colors.white54))
                : _buildNotificationCard(_current!),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final colors = _resolveColors(n);
    final time = n['_receivedAt'] is DateTime ? _formatTime(n['_receivedAt']) : '--:--:--';

    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 1.2),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_resolveIcon(n), color: colors.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n['title']?.toString() ?? 'Notification',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                if ((n['message']?.toString() ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    n['message'] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    NotificationListenerService().onNotification = null;
    super.dispose();
  }
}

class _NotifColors {
  final Color bg, border, accent, backgroundSnack;
  _NotifColors({required this.bg, required this.border, required this.accent, required this.backgroundSnack});
}
