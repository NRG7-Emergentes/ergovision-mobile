import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationListenerService {
  static final NotificationListenerService _instance =
  NotificationListenerService._internal();

  StompClient? _client;
  Function(Map<String, dynamic>)? onNotification;

  final ValueNotifier<Map<String, dynamic>?> latestNotification =
  ValueNotifier<Map<String, dynamic>?>(null);

  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  bool get isConnected => _client?.connected ?? false;

  /// NEW: userId actual
  int? _currentUserId;

  Future<void> connect(String token) async {
    if (isConnected) {
      debugPrint("[WS Mobile] Already connected");
      return;
    }

    // EXTRAEMOS el userId del token
    _currentUserId = getUserIdFromToken(token);
    debugPrint("[WS Mobile] Extracted userId: $_currentUserId");

    final url = "ws://10.0.2.2:8080/ws-notifications";
    debugPrint("[WS Mobile] Connecting to: $url");

    _client = StompClient(
      config: StompConfig(
        url: url,
        onConnect: _onConnect,
        onWebSocketError: (error) => debugPrint("[WS Mobile] Error: $error"),
        onDisconnect: (_) => debugPrint("[WS Mobile] Disconnected ❌"),
      ),
    );

    _client?.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint("[WS Mobile] CONNECTED ✅");

    _client?.subscribe(
      destination: "/topic/notifications",
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = json.decode(frame.body!);

            debugPrint("[WS Mobile] Notification received: $data");

            final notifUserId = data['userId'];

            // FILTRO por userId
            if (_currentUserId != null && notifUserId != _currentUserId) {
              debugPrint(
                  "[WS Mobile] Notification filtered out - intended for userId: $notifUserId, current: $_currentUserId");
              return;
            }

            latestNotification.value = {
              ...data,
              '_receivedAt': DateTime.now(),
            };

            onNotification?.call(data);
          } catch (_) {
            debugPrint("[WS Mobile] Error parsing notification");
          }
        }
      },
    );
  }

  // ----------- JWT Helpers -----------------

  int? getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);

      return payloadMap['userId'] ?? payloadMap['sub'];
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return null;
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }

  // -------------- SEND ---------------------

  void send(Map<String, dynamic> notif) {
    if (!isConnected) {
      debugPrint("[WS Mobile] Cannot send, not connected");
      return;
    }

    _client?.send(destination: "/app/notify", body: jsonEncode(notif));
    debugPrint("[WS Mobile] Notification sent: $notif");
  }

  // -------------- DISCONNECT ---------------

  void disconnect() {
    if (isConnected) {
      debugPrint("[WS Mobile] Disconnecting WebSocket...");
      _client?.deactivate();
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION LISTENER WIDGET (sin cambios en tu lógica visual)
// ════════════════════════════════════════════════════════════════════════════

class NotificationListenerWidget extends StatefulWidget {
  const NotificationListenerWidget({super.key});

  @override
  State<NotificationListenerWidget> createState() =>
      _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends State<NotificationListenerWidget> {
  Map<String, dynamic>? _current;

  @override
  void initState() {
    super.initState();

    final service = NotificationListenerService();

    service.onNotification = (data) {
      final colors = _resolveColors(data);

      setState(() {
        _current = {
          ...data,
          '_receivedAt': DateTime.now(),
          '_read': false,
        };
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_buildSnackText(data)),
            backgroundColor: colors.backgroundSnack,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    };
  }

  @override
  void dispose() {
    NotificationListenerService().onNotification = null;
    super.dispose();
  }

  String _buildSnackText(Map<String, dynamic> n) {
    final title = (n['title'] ?? '').toString();
    final msg = (n['message'] ?? '').toString();
    return title.isNotEmpty ? "$title: $msg" : msg;
  }

  _NotifColors _resolveColors(Map<String, dynamic> n) {
    final title = (n['title'] ?? '').toString().toUpperCase();

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
    final title = (n['title'] ?? '').toString().toUpperCase();
    if (title.contains('ACTIVE')) return Icons.play_arrow_rounded;
    if (title.contains('PAUSED')) return Icons.pause_circle_filled_rounded;
    if (title.contains('ERROR')) return Icons.error_outline;
    return Icons.notifications;
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final n = _current;
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (n == null)
              const Text(
                "Waiting for notification...",
                style: TextStyle(color: Colors.white54),
              )
            else
              _buildSingle(n),
          ],
        ),
      ),
    );
  }

  Widget _buildSingle(Map<String, dynamic> n) {
    final colors = _resolveColors(n);
    final icon = _resolveIcon(n);
    final time = n['_receivedAt'] is DateTime
        ? _formatTime(n['_receivedAt'] as DateTime)
        : '--:--:--';

    final title = (n['title'] ?? 'Notification').toString();
    final message = (n['message'] ?? '').toString();

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
          Icon(icon, color: colors.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifColors {
  final Color bg;
  final Color border;
  final Color accent;
  final Color backgroundSnack;
  _NotifColors({
    required this.bg,
    required this.border,
    required this.accent,
    required this.backgroundSnack,
  });
}
