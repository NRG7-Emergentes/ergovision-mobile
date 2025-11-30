import 'package:ergovision/shared/client/api_client.dart';
import 'package:ergovision/shared/models/update_user_request.dart';
import 'package:http/http.dart' as http;

class UserService{
  Future<http.Response> getUserProfile() async {
    return await ApiClient.get('users/me');
  }

  Future<http.Response> updateProfile(UpdateUserRequest request) async {
    return await ApiClient.put(
      'users',
      body: request.toJson(),
    );
  }
}