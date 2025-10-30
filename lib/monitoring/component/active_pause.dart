import 'package:flutter/material.dart';

class ActivePause extends StatefulWidget {
  const ActivePause({super.key});

  @override
  State<ActivePause> createState() => _ActivePauseState();
}

class _ActivePauseState extends State<ActivePause> {
  @override
  Widget build(BuildContext context) {
    bool hasPause = true;
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
              Text(
                'Active Pause',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: hasPause
                          ? [
                            Text(
                              'You have an active pause in progress',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Last active pause: ',
                                          style: TextStyle(color: Colors.white70, fontSize: 16),
                                        ),
                                        Text(
                                          '20:30:00',
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Next active pause: ',
                                          style: TextStyle(color: Colors.white70, fontSize: 16),
                                        ),
                                        Text(
                                          '22:30:00',
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'Current active pause',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Started at:',
                                            style: TextStyle(color: Colors.white70, fontSize: 16),
                                          ),
                                          Text(
                                            '21:30:00',
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Finish at:',
                                            style: TextStyle(color: Colors.white70, fontSize: 16),
                                          ),
                                          Text(
                                            '21:45:00',
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),


                              ],
                            )
                            ]
                          : [
                              Text(
                                'You have not initiated an active pause. Start an active pause to allow the application to monitor your breaks effectively.',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                      child: Card(
                        color: hasPause ? Color(0x664CAF50) : Color(0x66F44336),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.pause_circle_outline, color: hasPause ? Colors.green : Colors.red),
                        ),
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
