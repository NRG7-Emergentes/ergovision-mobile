import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ergovision/shared/bloc/auth/auth_event.dart';
import 'package:ergovision/shared/bloc/auth/auth_state.dart';
import 'package:ergovision/shared/client/api_client.dart';
import 'package:ergovision/shared/models/sign_in_request.dart';
import 'package:ergovision/shared/models/sign_in_response.dart';
import 'package:ergovision/shared/models/sign_up_response.dart';
import 'package:ergovision/shared/services/auth_service.dart';
import 'package:ergovision/shared/services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthService authService;
  final UserService userService;

  AuthBloc({required this.authService, required this.userService}) : super(AuthInitial()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<ResetAuthStateEvent>(_onResetAuthStateEvent);
  }

  void _onSignInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authService.signIn(
        SignInRequest(
          username: event.username,
          password: event.password,
        ),
      );

      if (response.statusCode == 200) {
        final signInResponse = SignInResponse.fromJson(
          json.decode(response.body),
        );
        ApiClient.updateToken(signInResponse.token);
        // Fetch user details
        final userResponse = await userService.getUserProfile();
        if (userResponse.statusCode == 200) {
          emit(SignInSuccess(signInResponse));
        } else if (userResponse.statusCode == 404) {
          emit(AuthFailure('It was not possible to find user information'));
        } else {
          emit(AuthFailure('Error while retrieving user details: \\nCode: \\${userResponse.statusCode}'));
        }
      } else {
        emit(AuthFailure('Login failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  Future<void> _onSignUpEvent(
      SignUpEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final response = await authService.signUp(event.request);

      if (response.statusCode == 201) {
        final signUpResponse = SignUpResponse.fromJson(json.decode(response.body));
        emit(SignUpSuccess(signUpResponse));
      } else {
        final error = json.decode(response.body)['message'] ?? 'Error while registering user';
        emit(AuthFailure(error));
      }
    } catch (e) {
      emit(AuthFailure('Connection error: $e'));
    }
  }

  void _onResetAuthStateEvent(
      ResetAuthStateEvent event,
      Emitter<AuthState> emit,
      ) {
    emit(AuthInitial());
  }
}