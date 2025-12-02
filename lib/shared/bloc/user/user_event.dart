import 'package:ergovision/shared/models/update_user_request.dart';

abstract class UserEvent {}

class FetchUserProfileEvent extends UserEvent {}

class UpdateUserProfileEvent extends UserEvent {
  final UpdateUserRequest request;

  UpdateUserProfileEvent(this.request);
}
