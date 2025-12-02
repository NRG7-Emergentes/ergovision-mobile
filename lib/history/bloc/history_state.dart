import 'package:ergovision/history/model/session_detail.dart';
import 'package:ergovision/history/model/session_summary.dart';

abstract class HistoryState {}

/// Initial state
class HistoryInitial extends HistoryState {}

/// Loading state
class HistoryLoading extends HistoryState {}

/// State when sessions list is loaded
class HistoryLoaded extends HistoryState {
  final List<SessionSummary> sessions;

  HistoryLoaded(this.sessions);
}

/// State when session detail is loaded
class SessionDetailLoaded extends HistoryState {
  final SessionDetail session;

  SessionDetailLoaded(this.session);
}

/// Error state
class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

