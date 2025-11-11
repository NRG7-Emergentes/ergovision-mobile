import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime receivedAt;

  NotificationItem({required this.title, required this.message, DateTime? receivedAt})
      : receivedAt = receivedAt ?? DateTime.now();

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString();
    final message = (json['message'] ?? '').toString();
    DateTime? parsed;
    try {
      final s = json['sentAt'] ?? json['createdAt'];
      if (s != null) parsed = DateTime.parse(s.toString());
    } catch (_) {}
    return NotificationItem(title: title.isEmpty ? 'Notification' : title, message: message, receivedAt: parsed);
  }
}

class NotificationListenerWidget extends StatefulWidget {
  const NotificationListenerWidget({super.key});

  @override
  State<NotificationListenerWidget> createState() => _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState extends State<NotificationListenerWidget> {
  StompClient? stompClient;
  final List<NotificationItem> _notifications = [];
  bool _connected = false;
  bool _expanded = false;
  static const int _maxItems = 6;

  @override
  void initState() {
    super.initState();
    _connectStomp();
  }

  void _connectStomp() {
    // adjust URL for emulator/device as needed
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws-notifications', // change if needed
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) {
          if (mounted) {
            setState(() => _connected = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('STOMP error: $error')));
          }
        },
        onDisconnect: (_) {
          if (mounted) setState(() => _connected = false);
        },
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    if (!mounted) return;
    setState(() => _connected = true);

    stompClient!.subscribe(
      destination: '/topic/notifications',
      callback: (StompFrame frame) {
        final raw = frame.body ?? '';
        // try parse JSON, fallback to plain text
        NotificationItem item;
        try {
          final data = json.decode(raw);
          if (data is Map<String, dynamic>) {
            item = NotificationItem.fromJson(data);
          } else {
            item = NotificationItem(title: 'Notification', message: raw.toString());
          }
        } catch (_) {
          item = NotificationItem(title: 'Notification', message: raw.toString());
        }

        if (!mounted) return;
        setState(() {
          _notifications.insert(0, item);
          if (_notifications.length > _maxItems) _notifications.removeRange(_maxItems, _notifications.length);
        });

        // nicer SnackBar
        final snackText = '${item.title}: ${item.message}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackText), duration: const Duration(seconds: 3)),
        );
      },
    );
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final t = dt.toLocal();
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final latest = _notifications.isNotEmpty ? _notifications.first : null;

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF1A2332),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A3A4A), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(_connected ? Icons.notifications_active : Icons.notifications_off,
                      color: _connected ? Colors.greenAccent : Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (_notifications.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B7FFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${_notifications.length}', style: const TextStyle(color: Colors.white)),
                    ),
                  IconButton(
                    icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: Colors.white70),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  )
                ],
              ),
              const SizedBox(height: 8),
              if (latest != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      latest.title.isNotEmpty ? latest.title[0].toUpperCase() : 'N',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(latest.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(latest.message, style: const TextStyle(color: Colors.white70)),
                  trailing: Text(_formatTime(latest.receivedAt), style: const TextStyle(color: Colors.white60)),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.white38, size: 16),
                      SizedBox(width: 8),
                      Text('Esperando notificaciones...', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              if (_expanded && _notifications.length > 1)
                const Divider(color: Colors.white12),
              if (_expanded)
                SizedBox(
                  height: 160,
                  child: _notifications.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.separated(
                          itemCount: _notifications.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 8),
                          itemBuilder: (_, i) {
                            final n = _notifications[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.primaries[i % Colors.primaries.length],
                                child: Text(n.title.isNotEmpty ? n.title[0].toUpperCase() : 'N', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text(n.title, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(n.message, style: const TextStyle(color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis),
                              trailing: Text(_formatTime(n.receivedAt), style: const TextStyle(color: Colors.white60, fontSize: 12)),
                            );
                          },
                        ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
