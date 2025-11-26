import 'dart:convert';
import 'package:ergovision/monitoring/component/active_pause.dart';
import 'package:ergovision/monitoring/component/notification_listener.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ergovision/shared/services/auth_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  final values = [60.0, 80.0, 40.0, 90.0, 70.0, 50.0, 30.0];

  final NotificationListenerService _ws = NotificationListenerService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // ===========================================================================
  // 🔥 Iniciar token + WebSocket (token + userId)
  // ===========================================================================
  Future<void> _initializeNotifications() async {
    await AuthService.instance.loadToken();

    final rawToken = AuthService.instance.token;
    if (rawToken == null || rawToken.trim().isEmpty) {
      debugPrint("[Dashboard] No token found — WebSocket not connected");
      return;
    }

    // Limpieza del token
    final token = rawToken.replaceAll('"', '');

    debugPrint("[Dashboard] Connecting WebSocket with token: $token");

    await _ws.connect(token);

    // Callback opcional
    _ws.onNotification = (data) {
      debugPrint("[Dashboard] WS Notification Received → $data");
    };
  }

  @override
  void dispose() {
    _ws.disconnect();
    super.dispose();
  }

  // ===========================================================================
  // 🔥 UI
  // ===========================================================================
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
                'Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // ================================
            // 🟦 Active Pause + Real-time card
            // ================================
            Column(
              children: [
                ActivePause(),
                const SizedBox(height: 8),

                // 🔥 Ahora usamos la instancia singleton real
                ValueListenableBuilder<Map<String, dynamic>?>(
                  valueListenable: _ws.latestNotification,
                  builder: (_, notif, __) {
                    if (notif == null) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'No active notification',
                          style: TextStyle(color: Colors.white54),
                          textAlign: TextAlign.left,
                        ),
                      );
                    }

                    final title = (notif['title'] ?? '').toString();
                    final msg = (notif['message'] ?? '').toString();

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: const Color(0xFF1A2332),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: Color(0xFF2A3A4A), width: 1.5),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Row(
                            children: [
                              Icon(
                                title.toUpperCase().contains('PAUSED')
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: title.toUpperCase().contains('PAUSED')
                                    ? Colors.amber
                                    : Colors.greenAccent,
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title.isEmpty
                                          ? 'Monitoring Update'
                                          : title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (msg.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        msg,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🔥 widget separado
            const NotificationListenerWidget(),

            const SizedBox(height: 10),

            // =====================================================
            // 🟦 Todo lo demás queda igual (cards, charts, etc.)
            // =====================================================

            _buildWelcomeCard(),
            const SizedBox(height: 10),
            _buildLast7DaysCard(),
            const SizedBox(height: 10),
            _buildWeeklyTimeCard(),
            const SizedBox(height: 10),
            _buildWeakPointCard(),
            const SizedBox(height: 10),
            _buildBarChartCard(),
          ],
        ),
      ),
    );
  }

  // ===================================================================
  // 🔥 Tus widgets originales (sin cambios)
  // ===================================================================

  Widget _buildWelcomeCard() {
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
          child: Row(
            children: [
              const SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WELCOME',
                        style:
                        TextStyle(color: Colors.white54, fontSize: 14)),
                    SizedBox(height: 5),
                    Text('Hello, Neo!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Card(
                color: const Color(0xFF121720),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Color(0xFF2A3A4A),
                    width: 2,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Text('LAST SESSION',
                          style:
                          TextStyle(color: Colors.white70, fontSize: 14)),
                      SizedBox(height: 5),
                      Text('82%',
                          style: TextStyle(
                              color: Color(0xFF2B7FFF),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLast7DaysCard() {
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
          child: Row(
            children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('LAST 7 DAYS',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 14)),
                      SizedBox(height: 5),
                      Text('Average Score',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('78.5%',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ]),
              ),
              const Spacer(),
              SizedBox(
                child: Card(
                  color: const Color(0x662B7FFF),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.bar_chart,
                        color: Color(0xFF2B7FFF)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyTimeCard() {
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
          child: Row(
            children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('THIS WEEK',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 14)),
                      SizedBox(height: 5),
                      Text('Total Monitored Time',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('4h 32m',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ]),
              ),
              const Spacer(),
              SizedBox(
                child: Card(
                  color: const Color(0x6700D3F2),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.watch_later_outlined,
                        color: Color(0xFF00D3F2)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeakPointCard() {
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
          child: Row(
            children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('MAIN FOCUS',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 14)),
                      SizedBox(height: 5),
                      Text('Most Common Weak Point',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('Shoulder',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ]),
              ),
              const Spacer(),
              SizedBox(
                child: Card(
                  color: const Color(0x66FFB900),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning_amber_outlined,
                        color: Color(0xFFFFB900)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartCard() {
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
                const Text("Score Progress",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Text("Last 7 days performance overview",
                    style: TextStyle(
                        color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.2,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      minY: 0,
                      alignment: BarChartAlignment.spaceAround,
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (_) =>
                        const FlLine(
                            color: Colors.white24, strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            getTitlesWidget:
                                (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              );
                            },
                            reservedSize: 36,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget:
                                (double value, TitleMeta meta) {
                              final index = value.toInt();
                              if (index < 0 ||
                                  index >= days.length) {
                                return const SizedBox();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  days[index],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              );
                            },
                            reservedSize: 36,
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(
                              color: Colors.white54, width: 1),
                          bottom: BorderSide(
                              color: Colors.white54, width: 1),
                        ),
                      ),
                      barGroups:
                      List.generate(days.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: values[index],
                              width: 15,
                              borderRadius:
                              BorderRadius.circular(4),
                              color: Colors.blueAccent,
                            ),
                          ],
                        );
                      }),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod,
                              rodIndex) {
                            return BarTooltipItem(
                              '${days[groupIndex]}: ${rod.toY.toInt()}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
