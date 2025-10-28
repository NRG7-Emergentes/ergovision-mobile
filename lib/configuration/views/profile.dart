import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Column(
        children: [
          const SizedBox(
              width: double.infinity,
              child: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              )
          ),
        ],
      ),
    );

  }
}
