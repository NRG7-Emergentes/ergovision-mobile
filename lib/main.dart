import 'package:ergovision/history/bloc/history_bloc.dart';
import 'package:ergovision/history/services/history_service.dart';
import 'package:ergovision/monitoring/bloc/session/session_bloc.dart';
import 'package:ergovision/monitoring/services/monitoring_service.dart';
import 'package:ergovision/shared/bloc/auth/auth_bloc.dart';
import 'package:ergovision/shared/bloc/user/user_bloc.dart';
import 'package:ergovision/shared/services/auth_service.dart';
import 'package:ergovision/shared/services/user_service.dart';
import 'package:ergovision/shared/views/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await AuthService.instance.loadToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authService: AuthService(),
            userService: UserService(),
          ),
        ),
        BlocProvider(
          create: (_) => UserBloc(
            userService: UserService(),
          ),
        ),
        BlocProvider(
          create: (_) => SessionBloc(
            monitoringService: MonitoringService(),
          ),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(
            historyService: HistoryService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'ErgoVision',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2A3A4A)),
        ),
        home: const SignIn(),
      ),
    );
  }
}