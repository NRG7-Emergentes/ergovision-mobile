import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Agregar esta importación

class NotificationListenerService {
  static final NotificationListenerService _instance = NotificationListenerService._internal();
  StompClient? _client;
  Function(Map<String, dynamic>)? onNotification;
  final ValueNotifier<Map<String, dynamic>?> latestNotification = ValueNotifier(null);

  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  bool get isConnected => _client?.connected ?? false;
  int? _currentUserId;

  Future<void> connect() async { // Removí el parámetro token
    if (isConnected) return;

    // Cargar el token desde AuthService o SharedPreferences
    final token = await _loadToken();
    if (token == null) {
      debugPrint('❌ No se pudo cargar el token');
      return;
    }

    _currentUserId = _extractUserIdFromToken(token);
    final url = "ws://10.0.2.2:8080/ws-notifications";

    _client = StompClient(
      config: StompConfig(
        url: url,
        onConnect: _onConnect,
        onWebSocketError: (_) => debugPrint("WebSocket error"),
        onDisconnect: (_) => debugPrint("Disconnected"),
      ),
    );

    _client?.activate();
  }

  // Nuevo método para cargar el token
  Future<String?> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt');
      debugPrint('🔐 Token loaded from storage: ${token != null ? "✓" : "✗"}');
      return token;
    } catch (e) {
      debugPrint('❌ Error loading token: $e');
      return null;
    }
  }

  void _onConnect(StompFrame frame) {
    debugPrint('✅ WebSocket connected successfully');
    _client?.subscribe(
      destination: "/topic/notifications",
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = json.decode(frame.body!);
            _handleIncomingNotification(data);
          } catch (_) {
            debugPrint("Error parsing notification");
          }
        }
      },
    );
  }

  void _handleIncomingNotification(Map<String, dynamic> data) {
    final notifUserId = data['userId'];

    debugPrint('🔔 Raw notification - UserID: $notifUserId, Current User: $_currentUserId, Title: ${data['title']}');

    // Filtrado más robusto
    if (_currentUserId != null && notifUserId != _currentUserId) {
      debugPrint('🚫 Notification FILTERED - not for current user');
      return;
    }

    if (_currentUserId == null) {
      debugPrint('⚠️  Current userId is NULL - accepting all notifications');
    } else {
      debugPrint('✅ Notification ACCEPTED - for current user $_currentUserId');
    }

    // Usar postFrameCallback para evitar llamadas durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      latestNotification.value = {
        ...data,
        '_receivedAt': DateTime.now(),
      };
    });

    onNotification?.call(data);
  }

  int? _extractUserIdFromToken(String token) {
    try {
      debugPrint('🔐 Token received: ${token.substring(0, 20)}...'); // Solo mostrar parte del token por seguridad

      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('❌ Invalid token format - expected 3 parts, got ${parts.length}');
        return null;
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);

      debugPrint('🔍 Token payload: $payloadMap');

      final userId = payloadMap['userId'] ?? payloadMap['sub'];
      debugPrint('✅ Extracted userId: $userId');

      return userId;
    } catch (e) {
      debugPrint('❌ Error decoding token: $e');
      return null;
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 2: output += '=='; break;
      case 3: output += '='; break;
      default: break;
    }

    return utf8.decode(base64Url.decode(output));
  }

  void send(Map<String, dynamic> notif) {
    if (!isConnected) return;
    _client?.send(destination: "/app/notify", body: jsonEncode(notif));
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

  @override
  void initState() {
    super.initState();
    NotificationListenerService().onNotification = _handleNotification;
  }

  void _handleNotification(Map<String, dynamic> data) {
    final colors = _resolveColors(data);

    // Usar postFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _current = {
            ...data,
            '_receivedAt': DateTime.now(),
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_buildSnackText(data)),
            backgroundColor: colors.backgroundSnack,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  String _buildSnackText(Map<String, dynamic> n) {
    final title = n['title']?.toString() ?? '';
    final msg = n['message']?.toString() ?? '';
    return title.isNotEmpty ? "$title: $msg" : msg;
  }

  _NotifColors _resolveColors(Map<String, dynamic> n) {
    final title = (n['title']?.toString() ?? '').toUpperCase();

    if (title.contains('ACTIVE')) {
      return _NotifColors(
        bg: const Color(0xFF0F2A1F),
        border: const Color(0xFF20C997),
        accent: const Color(0xFF20C997),
        backgroundSnack: const Color(0xFF1E664E),
      );
    }

    if (title.contains('PAUSED')) {
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
    final title = (n['title']?.toString() ?? '').toUpperCase();
    if (title.contains('ACTIVE')) return Icons.play_arrow_rounded;
    if (title.contains('PAUSED')) return Icons.pause_circle_filled_rounded;
    return Icons.notifications;
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
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
    final time = n['_receivedAt'] is DateTime ? _formatTime(n['_receivedAt'] as DateTime) : '--:--:--';

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
                    n['message']?.toString() ?? '',
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