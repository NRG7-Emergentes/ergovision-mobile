import 'package:equatable/equatable.dart';
import '../../model/session.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SessionInitial extends SessionState {}

/// Estado de carga
class SessionLoading extends SessionState {}

/// Estado cuando las sesiones se cargaron exitosamente
class SessionsLoaded extends SessionState {
  final List<Session> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

/// Estado cuando el detalle de una sesión se cargó exitosamente
class SessionDetailLoaded extends SessionState {
  final Session session;

  const SessionDetailLoaded(this.session);

  @override
  List<Object?> get props => [session];
}

/// Estado de error
class SessionError extends SessionState {
  final String message;

  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado cuando no hay sesiones
class SessionsEmpty extends SessionState {}
