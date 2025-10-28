import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                      SizedBox(height: 5),
                      SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            'Graph Placeholder',
                            style: TextStyle(color: Colors.white30, fontSize: 16, fontStyle: FontStyle.italic),
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
