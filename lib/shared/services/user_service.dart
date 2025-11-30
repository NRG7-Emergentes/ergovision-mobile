import 'package:ergovision/shared/client/api_client.dart';
import 'package:http/http.dart' as http;

class UserService{
  Future<http.Response> getUserProfile() async {
    return await ApiClient.get('users/me');
  }
}