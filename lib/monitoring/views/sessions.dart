import 'package:flutter/material.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Text(
                'Sessions',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              )
          ),
        ],
      ),
    );

  }
}
