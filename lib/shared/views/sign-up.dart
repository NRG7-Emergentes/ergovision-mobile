import 'package:ergovision/shared/bloc/auth/auth_bloc.dart';
import 'package:ergovision/shared/bloc/auth/auth_event.dart';
import 'package:ergovision/shared/bloc/auth/auth_state.dart';
import 'package:ergovision/shared/bloc/user/user_bloc.dart';
import 'package:ergovision/shared/models/sign_up_request.dart';
import 'package:ergovision/shared/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    photoUrlController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
  }

  void registerAndLogin(BuildContext context) {
    if (passwordController1.text != passwordController2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final request = SignUpRequest(
        username: usernameController.text,
        email: emailController.text,
        imageUrl: photoUrlController.text,
        age: int.tryParse(ageController.text) ?? 0,
        height: int.tryParse(heightController.text) ?? 0,
        weight: double.tryParse(weightController.text) ?? 0.0,
        password: passwordController1.text
    );

    context.read<AuthBloc>().add(SignUpEvent(request: request));
  }

  Future<void> handlePostSignIn() async {
    final userService = UserService();
    try {
      final response = await userService.getUserProfile();
      if (!mounted) return;

      if (response.statusCode == 200) {
        if (mounted) setState(() => isLoading = false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (_) => UserBloc(userService: UserService()),
                    child: const Home()
                )
            )
        );
      } else {
        if (mounted) setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user profile: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            context.read<AuthBloc>().add(
              SignInEvent(
                username: usernameController.text,
                password: passwordController1.text,
              ),
            );
          } else if (state is SignInSuccess) {
            handlePostSignIn();
          } else if (state is AuthFailure) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
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
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFA8B0B8)),
                    hintStyle: TextStyle(color: Color(0xFFA8B0B8)),
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFA8B0B8)),
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
                    onPressed: isLoading ? null : () => registerAndLogin(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color(0xFF2B7FFF)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child:isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ) :
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
        ),
      ),
    );
  }
}