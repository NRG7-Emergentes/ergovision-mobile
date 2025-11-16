import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // estado para el switch
  bool enableMailNotifications = true;
  bool enablePostureNotifications = true;
  bool enableAppNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              )
          ),
          SizedBox(height: 10),
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
                child:
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enable Mail Notifications',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Switch(
                            value: enableMailNotifications,
                            onChanged: (bool val) {
                              setState(() {
                                enableMailNotifications = val;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enable on Posture Notifications',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Switch(
                            value: enablePostureNotifications,
                            onChanged: (bool val) {
                              setState(() {
                                enablePostureNotifications = val;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enable on App Notifications',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Switch(
                            value: enableAppNotifications,
                            onChanged: (bool val) {
                              setState(() {
                                enableAppNotifications = val;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              )
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Guardar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
          )
        ]
      ),
    );

  }
}
