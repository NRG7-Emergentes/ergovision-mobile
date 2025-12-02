import 'package:ergovision/shared/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserUpdating extends UserState {
  final User currentUser;

  UserUpdating(this.currentUser);
}

class UserUpdateSuccess extends UserState {
  final User user;

  UserUpdateSuccess(this.user);
}

class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);
}