import 'package:ergovision/shared/client/api_client.dart';
import 'package:http/http.dart' as http;

class MonitoringService {
  /// Obtiene todas las sesiones de monitoreo del usuario autenticado
  Future<http.Response> getUserSessions(int userId) async {
    return await ApiClient.get('monitoringSession/user/$userId');
  }

  /// Obtiene el detalle de una sesión específica por su ID
  Future<http.Response> getSessionById(String sessionId) async {
    return await ApiClient.get('monitoringSession/$sessionId');
  }

  /// Crea una nueva sesión de monitoreo
  Future<http.Response> createSession(Map<String, dynamic> sessionData) async {
    return await ApiClient.post('monitoringSession', body: sessionData);
  }

  /// Actualiza una sesión de monitoreo existente
  Future<http.Response> updateSession(String sessionId, Map<String, dynamic> sessionData) async {
    return await ApiClient.put('monitoringSession/$sessionId', body: sessionData);
  }

  /// Elimina una sesión de monitoreo
  Future<http.Response> deleteSession(String sessionId) async {
    return await ApiClient.delete('monitoringSession/$sessionId');
  }
}
