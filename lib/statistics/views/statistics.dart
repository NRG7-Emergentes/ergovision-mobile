import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ergovision/statistics/bloc/statistics_bloc.dart';
import 'package:ergovision/statistics/bloc/statistics_event.dart';
import 'package:ergovision/statistics/bloc/statistics_state.dart';
import 'package:ergovision/statistics/models/statistics.dart' as stats_model;
import 'package:ergovision/statistics/models/mothly_progress.dart';
import 'package:ergovision/statistics/models/daily_progress.dart';
import 'package:ergovision/statistics/services/statistics_service.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc(
        statisticsService: StatisticsService(),
      )..add(LoadStatisticsEvent()),
      child: const StatisticsScreen(),
    );
  }
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: BlocConsumer<StatisticsBloc, StatisticsState>(
        listener: (context, state) {
          if (state is StatisticsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(StatisticsState state) {
    if (state is StatisticsLoading) {
      return _buildLoading();
    } else if (state is StatisticsError) {
      return _buildError(state);
    } else if (state is StatisticsSuccess) {
      return _buildContent(state.statistics);
    } else {
      return _buildLoading();
    }
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildLoadingCard(),
          const SizedBox(height: 10),
          _buildLoadingCard(),
          const SizedBox(height: 10),
          _buildLoadingChart(),
          const SizedBox(height: 10),
          _buildLoadingCard(),
          const SizedBox(height: 10),
          _buildLoadingCard(),
          const SizedBox(height: 10),
          _buildLoadingPieChart(),
        ],
      ),
    );
  }

  Widget _buildError(StatisticsError state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Statistics',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<StatisticsBloc>().add(LoadStatisticsEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FFF),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Try Again', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(stats_model.Statistics statistics) {

    final monthlyData = _getMonthlyData(statistics.monthlyProgresses);
    final pieData = _calculatePieChartData(statistics.dailyProgresses);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),

          _buildStatCard(
            title: 'All Time Average Score',
            value: statistics.globalAverageScore.toStringAsFixed(1),
            unit: '%',
            description: 'Your overall posture quality score',
            icon: Icons.bar_chart,
            iconColor: const Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 10),

          _buildStatCard(
            title: 'Average Session Time',
            value: statistics.averageSessionTimeMinutes.toStringAsFixed(0),
            unit: 'min',
            description: 'Average monitoring duration',
            icon: Icons.watch_later_outlined,
            iconColor: const Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 10),

          _buildBarChart(monthlyData.months, monthlyData.values),
          const SizedBox(height: 10),

          _buildStatCard(
            title: 'Average Active Pauses',
            value: statistics.averagePausesPerSession.toStringAsFixed(1),
            unit: 'per session',
            description: 'Rest breaks per monitoring session',
            icon: Icons.pause_circle_outline,
            iconColor: const Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 10),

          _buildStatCard(
            title: 'Total Time Monitored',
            value: statistics.totalMonitoredHours.toStringAsFixed(0),
            unit: 'h',
            description: 'Total time you had monitored your posture',
            icon: Icons.timer_outlined,
            iconColor: const Color(0xFF2B7FFF),
          ),
          const SizedBox(height: 10),

          _buildPieChart(pieData),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Statistics',
        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A4A), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 20,
                color: Colors.grey[800],
              ),
              const SizedBox(height: 10),
              Container(
                width: 80,
                height: 40,
                color: Colors.grey[800],
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 14,
                color: Colors.grey[800],
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A4A), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 20,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 8),
          Container(
            width: 250,
            height: 16,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[800],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPieChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A4A), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 250,
            height: 20,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 8),
          Container(
            width: 300,
            height: 16,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.grey[800],
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          unit,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Card(
                color: iconColor.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon, color: iconColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<String> months, List<double> values) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              const Text(
                'Score Progress - Last 4 Months',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your posture score trend over time',
                style: TextStyle(color: Colors.white54, fontSize: 16),
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
                        horizontalInterval: 20,
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
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 14),
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
                              final i = value.toInt();
                              if (i < 0 || i >= months.length) return const SizedBox();
                              return Text(
                                months[i],
                                style: const TextStyle(color: Colors.white, fontSize: 14),
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
                      barGroups: List.generate(months.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: values[index],
                              width: 40,
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blueAccent,
                            ),
                          ],
                          showingTooltipIndicators: [],
                        );
                      }),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${months[groupIndex]}: ${rod.toY.toInt()}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> pieData) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    int colorIndex = 0;
    final sections = pieData.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        value: entry.value,
        color: color,
        title: '${entry.value.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              const Text(
                'Posture Quality Distribution',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Breakdown of your posture quality levels',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          startDegreeOffset: -90,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < pieData.entries.length; i++) ...[
                            LegendItem(
                              color: colors[i % colors.length],
                              text: '${pieData.entries.toList()[i].key} (${pieData.entries.toList()[i].value.toStringAsFixed(0)}%)',
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({List<String> months, List<double> values}) _getMonthlyData(List<MothlyProgress> monthlyProgresses) {
    if (monthlyProgresses.isEmpty) {
      return (
      months: ['May', 'June', 'July', 'August'],
      values: [10.0, 41.0, 35.0, 51.0]
      );
    }


    final sorted = monthlyProgresses
        .map((mp) => (
    month: _formatMonth(mp.month),
    value: mp.averageScore
    ))
        .toList()
        .reversed
        .take(4)
        .toList();


    while (sorted.length < 4) {
      sorted.add((
      month: _getDefaultMonth(sorted.length),
      value: 0.0
      ));
    }

    return (
    months: sorted.map((item) => item.month).toList(),
    values: sorted.map((item) => item.value).toList()
    );
  }

  String _formatMonth(String monthString) {
    try {
      final parts = monthString.split('-');
      if (parts.length == 2) {
        final month = int.parse(parts[1]);
        final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        if (month >= 1 && month <= 12) {
          return monthNames[month - 1];
        }
      }
    } catch (e) {
      print('Error formatting month: $e');
    }
    return monthString;
  }

  String _getDefaultMonth(int index) {
    final monthNames = ['May', 'June', 'July', 'August'];
    return monthNames[index % monthNames.length];
  }

  Map<String, double> _calculatePieChartData(List<DailyProgress> dailyProgresses) {
    if (dailyProgresses.isEmpty) {
      return {
        'Excellent': 40.0,
        'Good': 30.0,
        'Average': 20.0,
        'Poor': 10.0,
      };
    }


    int excellent = 0;
    int good = 0;
    int average = 0;
    int poor = 0;

    for (final progress in dailyProgresses) {
      final score = progress.averageScore;
      if (score >= 80) {
        excellent++;
      } else if (score >= 60) {
        good++;
      } else if (score >= 40) {
        average++;
      } else {
        poor++;
      }
    }

    final total = dailyProgresses.length.toDouble();

    return {
      'Excellent': total > 0 ? (excellent / total * 100) : 0.0,
      'Good': total > 0 ? (good / total * 100) : 0.0,
      'Average': total > 0 ? (average / total * 100) : 0.0,
      'Poor': total > 0 ? (poor / total * 100) : 0.0,
    };
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}