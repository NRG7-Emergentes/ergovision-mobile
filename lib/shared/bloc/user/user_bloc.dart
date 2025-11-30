import 'package:ergovision/shared/bloc/user/user_event.dart';
import 'package:ergovision/shared/bloc/user/user_state.dart';
import 'package:ergovision/shared/services/user_service.dart';
import 'dart:convert';
import 'package:bloc/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await userService.getUserProfile();
      if (response.statusCode == 200) {
        final userProfile = json.decode(response.body);
        emit(UserLoaded(userProfile));
      } else {
        emit(UserFailure('Failed to load user profile: ${response.statusCode}'));
      }
    } catch (e) {
      emit(UserFailure('Error: $e'));
    }
  }
}