import 'package:ergovision/shared/client/api_client.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  // El backend obtiene el userId del token de autenticación
  Future<http.Response> getStatistics() async {
    return await ApiClient.get('statistics/me');
  }

}
