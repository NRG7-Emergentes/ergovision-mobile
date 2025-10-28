import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController photoUrlController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController heightController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController passwordController1 = TextEditingController();
    final TextEditingController passwordController2 = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF121720),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
          top: 40,
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Name',
                      labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.abc, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: surnameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Surname',
                      hintText: 'Surname',
                      labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.abc, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Username',
                labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                prefixIcon: const Icon(Icons.person, color: Color(0xFFA8B0B8)),
                filled: true,
                fillColor: const Color(0xFF1A2332),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: photoUrlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Photo Url',
                hintText: 'Photo Url',
                labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                prefixIcon: const Icon(Icons.link, color: Color(0xFFA8B0B8)),
                filled: true,
                fillColor: const Color(0xFF1A2332),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: 'Age',
                labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                prefixIcon: const Icon(Icons.date_range, color: Color(0xFFA8B0B8)),
                filled: true,
                fillColor: const Color(0xFF1A2332),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: heightController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      hintText: 'Height (cm)',
                      labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      hintText: 'Weight (kg)',
                      labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                      prefixIcon: const Icon(Icons.accessibility_new_rounded, color: Color(0xFFA8B0B8)),
                      filled: true,
                      fillColor: const Color(0xFF1A2332),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController1,
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
            const SizedBox(height: 20),
            TextField(
              controller: passwordController2,
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
            const SizedBox(height: 20),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Home()
                      )
                  );
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
