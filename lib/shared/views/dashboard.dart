import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ergovision/monitoring/component/notification_listener.dart';
import 'package:ergovision/shared/client/api_client.dart';
import 'package:ergovision/statistics/bloc/statistics_bloc.dart';
import 'package:ergovision/statistics/bloc/statistics_event.dart';
import 'package:ergovision/statistics/bloc/statistics_state.dart';
import 'package:ergovision/statistics/models/statistics.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final NotificationListenerService _wsService = NotificationListenerService();

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();

    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsBloc>().add(LoadStatisticsEvent());
    });
  }

  Future<void> _initializeWebSocket() async {
    final token = ApiClient.getToken();
    if (token.isNotEmpty) {
      try {
        await _wsService.connect(token);
      } catch (e) {
        debugPrint("[Dashboard] WebSocket connection error: $e");
      }
    } else {
      debugPrint("[Dashboard] No token found, WS not connected");
    }
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: const Color(0xFF121720),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                      )
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const NotificationListenerWidget(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
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
                                          Text(
                                            'WELCOME',
                                            style: TextStyle(color: Colors.white54, fontSize: 14),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Hello, Neo!',
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ]
                                    )
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                        children: [
                                          const Text(
                                            'LAST SESSION',
                                            style: TextStyle(color: Colors.white70, fontSize: 14),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            state is StatisticsSuccess && state.statistics.dailyProgresses.isNotEmpty
                                                ? '${_getLastSessionScore(state.statistics.dailyProgresses).toStringAsFixed(0)}%'
                                                : '82%',
                                            style: const TextStyle(color: Color(0xFF2B7FFF), fontSize: 18, fontWeight: FontWeight.bold),
                                          )
                                        ]
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.trending_up,
                                              color: state is StatisticsSuccess && _getImprovementStatus(state.statistics) == 'improving'
                                                  ? Colors.green
                                                  : Colors.green,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              state is StatisticsSuccess
                                                  ? _getImprovementStatus(state.statistics)
                                                  : 'improving',
                                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.local_fire_department_sharp, color: Colors.red, size: 14),
                                            const SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'STREAK',
                                                  style: TextStyle(color: Colors.white54, fontSize: 12),
                                                ),
                                                Text(
                                                  state is StatisticsSuccess
                                                      ? '${_calculateStreak(state.statistics.dailyProgresses)} days'
                                                      : '5 days',
                                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ]
                                  ),
                                )
                              ],
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
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
                                  children: [
                                    const Text(
                                      'LAST 7 DAYS',
                                      style: TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Average Score',
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      state is StatisticsSuccess
                                          ? '${_calculateWeeklyAverageScore(state.statistics.dailyProgresses).toStringAsFixed(1)}%'
                                          : '78.5%',
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                                child: Card(
                                  color: const Color(0x662B7FFF),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.bar_chart, color: Color(0xFF2B7FFF)),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
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
                                  children: [
                                    const Text(
                                      'THIS WEEK',
                                      style: TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Total Monitored Time',
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      state is StatisticsSuccess
                                          ? _formatTotalMonitoredTime(state.statistics.totalMonitoredHours)
                                          : '4h 32m',
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ]
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                                child: Card(
                                  color: const Color(0x6700D3F2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.watch_later_outlined, color: Color(0xFF00D3F2)),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Score Progress',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Last 7 days performance overview',
                                  style: TextStyle(color: Colors.white54, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              child: AspectRatio(
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
                                      getDrawingHorizontalLine: (value) => FlLine(
                                        color: Colors.white24,
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 20,
                                          getTitlesWidget: (double value, TitleMeta meta) {
                                            return SideTitleWidget(
                                              meta: meta,
                                              child: Text(
                                                value.toInt().toString(),
                                                style: const TextStyle(color: Colors.white, fontSize: 14),
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
                                          getTitlesWidget: (double value, TitleMeta meta) {
                                            final days = state is StatisticsSuccess
                                                ? _getLast7DaysNames(state.statistics.dailyProgresses)
                                                : ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
                                            final i = value.toInt();
                                            if (i < 0 || i >= days.length) return const SizedBox();
                                            return SideTitleWidget(
                                              meta: meta,
                                              child: Text(
                                                days[i],
                                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                              ),
                                            );
                                          },
                                          reservedSize: 36,
                                        ),
                                      ),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(
                                        left: BorderSide(color: Colors.white54, width: 1),
                                        bottom: BorderSide(color: Colors.white54, width: 1),
                                        right: BorderSide.none,
                                        top: BorderSide.none,
                                      ),
                                    ),
                                    barGroups: _buildBarGroups(state),
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                          final days = state is StatisticsSuccess
                                              ? _getLast7DaysNames(state.statistics.dailyProgresses)
                                              : ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
                                          final values = state is StatisticsSuccess
                                              ? _getLast7DaysValues(state.statistics.dailyProgresses)
                                              : [60.0, 80.0, 40.0, 90.0, 70.0, 50.0, 30.0];
                                          return BarTooltipItem(
                                            '${days[groupIndex]}: ${values[groupIndex].toInt()}',
                                            const TextStyle(color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }


  double _getLastSessionScore(List<dynamic> dailyProgresses) {
    if (dailyProgresses.isEmpty) return 82.0;

    return dailyProgresses.first.averageScore?.toDouble() ?? 82.0;
  }

  String _getImprovementStatus(Statistics statistics) {
    if (statistics.monthlyProgresses.length < 2) return 'improving';

    final sortedMonths = statistics.monthlyProgresses.toList()
      ..sort((a, b) => b.month.compareTo(a.month));

    if (sortedMonths.length >= 2) {
      final current = sortedMonths[0].averageScore;
      final previous = sortedMonths[1].averageScore;
      return current > previous ? 'improving' : 'stable';
    }

    return 'improving';
  }

  int _calculateStreak(List<dynamic> dailyProgresses) {
    if (dailyProgresses.isEmpty) return 5;

    try {
      final sorted = dailyProgresses
          .where((day) => day.date != null)
          .map((day) => DateTime.parse(day.date))
          .toList()
        ..sort((a, b) => b.compareTo(a));

      if (sorted.isEmpty) return 5;

      int streak = 1;
      DateTime currentDate = sorted.first;

      for (int i = 1; i < sorted.length; i++) {
        final nextDate = sorted[i];
        final diff = currentDate.difference(nextDate).inDays;

        if (diff == 1) {
          streak++;
          currentDate = nextDate;
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      return 5;
    }
  }

  double _calculateWeeklyAverageScore(List<dynamic> dailyProgresses) {
    if (dailyProgresses.isEmpty) return 78.5;

    final last7Days = dailyProgresses.take(7).toList();
    if (last7Days.isEmpty) return 78.5;

    final sum = last7Days
        .where((day) => day.averageScore != null)
        .map((day) => day.averageScore.toDouble())
        .fold(0.0, (prev, score) => prev + score);

    return sum / last7Days.length;
  }

  String _formatTotalMonitoredTime(double totalHours) {
    if (totalHours == 0) return '4h 32m';

    final weeklyHours = totalHours / 4.3;
    final hours = weeklyHours.floor();
    final minutes = ((weeklyHours - hours) * 60).round();

    return '${hours}h ${minutes}m';
  }

  List<String> _getLast7DaysNames(List<dynamic> dailyProgresses) {
    if (dailyProgresses.isEmpty) {
      return ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
    }

    final last7Days = dailyProgresses.take(7).toList();
    final dayNames = <String>[];

    for (final day in last7Days) {
      try {
        final date = DateTime.parse(day.date);
        final days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
        dayNames.add(days[date.weekday - 1]);
      } catch (e) {
        dayNames.add('Day');
      }
    }

    // Completar si hay menos de 7 días
    while (dayNames.length < 7) {
      final defaultDays = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
      dayNames.add(defaultDays[dayNames.length % 7]);
    }

    return dayNames;
  }

  List<double> _getLast7DaysValues(List<dynamic> dailyProgresses) {
    if (dailyProgresses.isEmpty) {
      return [60.0, 80.0, 40.0, 90.0, 70.0, 50.0, 30.0];
    }

    final last7Days = dailyProgresses.take(7).toList();
    final List<double> values = last7Days
        .map((day) => day.averageScore?.toDouble() ?? 0.0)
        .cast<double>()
        .toList();

    // Completar si hay menos de 7 días solo con ceros 
    while (values.length < 7) {
      values.add(0.0);
    }

    return values;
  }

  List<BarChartGroupData> _buildBarGroups(StatisticsState state) {
    final days = state is StatisticsSuccess
        ? _getLast7DaysNames(state.statistics.dailyProgresses)
        : ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
    final values = state is StatisticsSuccess
        ? _getLast7DaysValues(state.statistics.dailyProgresses)
        : [60.0, 80.0, 40.0, 90.0, 70.0, 50.0, 30.0];

    return List.generate(days.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            width: 15,
            borderRadius: BorderRadius.circular(4),
            color: Colors.blueAccent,
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }
}