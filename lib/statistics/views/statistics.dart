import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  final months = ['May', 'June', 'July', 'August'];
  final values = [10.0, 41.0, 35.0, 51.0];

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
                  'Statistics',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Time Average Score',
                            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '85',
                                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '%',
                                style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Your overall posture quality score',
                            style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Session Time',
                            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '45',
                                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'min',
                                style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Average monitoring duration',
                            style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          SizedBox(
                              child: Card(
                                color: const Color(0x662B7FFF),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.watch_later_outlined, color: Color(0xFF2B7FFF)),
                                ),
                              )
                          )
                        ],
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
                      Text(
                        'Score Progress - Last 4 Months',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Your posture score trend over time',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
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
                                      if (i < 0 || i >= months.length) return const SizedBox();
                                      return SideTitleWidget(
                                        meta: meta,
                                        child: Text(
                                          months[i],
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
                              barGroups: List.generate(months.length, (index) {
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: values[index],
                                      width: 50,
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
                                      '${months[groupIndex]}: ${rod.toY.toInt()}',
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
                )
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Active Pauses',
                            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '3.2',
                                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'per session',
                                style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Rest breaks per monitoring session',
                            style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          SizedBox(
                              child: Card(
                                color: const Color(0x662B7FFF),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.pause_circle_outline, color: Color(0xFF2B7FFF)),
                                ),
                              )
                          )
                        ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Time Monitored',
                            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '12',
                                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'h',
                                style: TextStyle(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Total time you had monitored your posture',
                            style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          SizedBox(
                              child: Card(
                                color: const Color(0x662B7FFF),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.timer_outlined, color: Color(0xFF2B7FFF)),
                                ),
                              )
                          )
                        ],
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
                      Text(
                      'Posture Quality Distribution',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Breakdown of your posture quality levels',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      value: 40,
                                      color: Colors.blue,
                                      title: '40%',
                                      radius: 100,
                                      titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    PieChartSectionData(
                                      value: 30,
                                      color: Colors.green,
                                      title: '30%',
                                      radius: 100,
                                      titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    PieChartSectionData(
                                      value: 20,
                                      color: Colors.orange,
                                      title: '20%',
                                      radius: 100,
                                      titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    PieChartSectionData(
                                      value: 10,
                                      color: Colors.red,
                                      title: '10%',
                                      radius: 100,
                                      titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  LegendItem(color: Colors.blue, text: 'Azul'),
                                  SizedBox(height: 8),
                                  LegendItem(color: Colors.green, text: 'Verde'),
                                  SizedBox(height: 8),
                                  LegendItem(color: Colors.orange, text: 'Naranja'),
                                  SizedBox(height: 8),
                                  LegendItem(color: Colors.red, text: 'Rojo'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  )
                )
              )
            )
          ],
        ),
      ),
    );

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
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
