import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];
  final values = [60.0, 80.0, 40.0, 90.0, 70.0, 50.0, 30.0];

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
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Column(
                                  children: [
                                    Text(
                                      'LAST SESSION',
                                      style: TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '82%',
                                      style: TextStyle(color: Color(0xFF2B7FFF), fontSize: 18, fontWeight: FontWeight.bold),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const SizedBox(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.trending_up, color: Colors.green, size: 14),
                                      SizedBox(width: 5),
                                      Text(
                                        'improving',
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.local_fire_department_sharp, color: Colors.red, size: 14),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'STREAK',
                                            style: TextStyle(color: Colors.white54, fontSize: 12),
                                          ),
                                          Text(
                                            '5 days',
                                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
                            children: const [
                              Text(
                                'LAST 7 DAYS',
                                style: TextStyle(color: Colors.white54, fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Average Score',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '78.5%',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]
                        ),
                      ),
                      Spacer(),
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
                            children: const [
                              Text(
                                'THIS WEEK',
                                style: TextStyle(color: Colors.white54, fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Total Monitored Time',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '4h 32m',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]
                        ),
                      ),
                      Spacer(),
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
                            children: const [
                              Text(
                                'MAIN FOCUS',
                                style: TextStyle(color: Colors.white54, fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Most Common Weak Point',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Shoulder',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                          child: Card(
                            color: const Color(0x66FFB900),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.warning_amber_outlined, color: Color(0xFFFFB900)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score Progress',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Last 7 days performance overview',
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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
                              barGroups: List.generate(days.length, (index) {
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
                                  showingTooltipIndicators: [], // no mostrar etiquetas fijas
                                );
                              }),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${days[groupIndex]}: ${rod.toY.toInt()}',
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
  }
}
