import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar las sesiones del usuario autenticado
class FetchUserSessionsEvent extends SessionEvent {
  final int userId;

  const FetchUserSessionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Evento para cargar el detalle de una sesión específica
class FetchSessionDetailEvent extends SessionEvent {
  final String sessionId;

  const FetchSessionDetailEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

/// Evento para refrescar las sesiones
class RefreshSessionsEvent extends SessionEvent {
  final int userId;

  const RefreshSessionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
