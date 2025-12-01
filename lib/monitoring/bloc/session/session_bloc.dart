import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ergovision/monitoring/services/monitoring_service.dart';
import '../../model/session.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final MonitoringService monitoringService;

  SessionBloc({required this.monitoringService}) : super(SessionInitial()) {
    on<FetchUserSessionsEvent>(_onFetchUserSessions);
    on<FetchSessionDetailEvent>(_onFetchSessionDetail);
    on<RefreshSessionsEvent>(_onRefreshSessions);
  }

  /// Maneja el evento de cargar sesiones del usuario
  Future<void> _onFetchUserSessions(
    FetchUserSessionsEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    
    try {
      final response = await monitoringService.getUserSessions(event.userId);
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Session> sessions = jsonData
            .map((json) => Session.fromJson(json as Map<String, dynamic>))
            .toList();
        
        if (sessions.isEmpty) {
          emit(SessionsEmpty());
        } else {
          emit(SessionsLoaded(sessions));
        }
      } else {
        emit(SessionError('Failed to load sessions: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SessionError('Error loading sessions: $e'));
    }
  }

  /// Maneja el evento de cargar el detalle de una sesión
  Future<void> _onFetchSessionDetail(
    FetchSessionDetailEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    
    try {
      final response = await monitoringService.getSessionById(event.sessionId);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Session session = Session.fromJson(jsonData);
        emit(SessionDetailLoaded(session));
      } else {
        emit(SessionError('Failed to load session detail: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SessionError('Error loading session detail: $e'));
    }
  }

  /// Maneja el evento de refrescar sesiones
  Future<void> _onRefreshSessions(
    RefreshSessionsEvent event,
    Emitter<SessionState> emit,
  ) async {
    // Reutiliza la lógica de fetch
    await _onFetchUserSessions(
      FetchUserSessionsEvent(event.userId),
      emit,
    );
  }
}
