import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              'ErgoVision',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: Image.asset(
                'images/ergovision_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Welcome to ErgoVision. Please log in to continue.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Insert Username',
                hintText: 'Username',
                labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                prefixIcon: Icon(Icons.person, color: Color(0xFFA8B0B8)),
                filled: true,
                fillColor: Color(0xFF1A2332),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Insert Password',
                hintText: 'password',
                labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                prefixIcon: Icon(Icons.lock, color: Color(0xFFA8B0B8)),
                filled: true,
                fillColor: Color(0xFF1A2332),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  // Implement login logic here
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color(0xFF2B7FFF)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child:
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  // Implement login logic here
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color(0xFF232D3A)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child:
                Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
