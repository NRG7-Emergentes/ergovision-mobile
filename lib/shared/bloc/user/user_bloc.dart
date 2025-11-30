import 'package:ergovision/shared/bloc/user/user_event.dart';
import 'package:ergovision/shared/bloc/user/user_state.dart';
import 'package:ergovision/shared/services/user_service.dart';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ergovision/shared/models/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await userService.getUserProfile();
      if (response.statusCode == 200) {
        final userProfile = User.fromJson(json.decode(response.body));
        emit(UserLoaded(userProfile));
      } else {
        emit(UserFailure('Failed to load user profile: ${response.statusCode}'));
      }
    } catch (e) {
      emit(UserFailure('Error: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    // Keep current user data while updating
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(UserUpdating(currentState.user));
    } else {
      emit(UserLoading());
    }

    try {
      final response = await userService.updateProfile(event.request);
      if (response.statusCode == 200) {
        // Fetch updated user profile
        final userResponse = await userService.getUserProfile();
        if (userResponse.statusCode == 200) {
          final updatedUser = User.fromJson(json.decode(userResponse.body));
          emit(UserUpdateSuccess(updatedUser));
          // Transition to loaded state
          emit(UserLoaded(updatedUser));
        } else {
          emit(UserFailure('Failed to fetch updated profile'));
        }
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Failed to update profile';
        emit(UserFailure(errorMessage));
      }
    } catch (e) {
      emit(UserFailure('Error updating profile: $e'));
    }
  }
}