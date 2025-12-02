abstract class HistoryEvent {}

/// Event to fetch all sessions
class FetchHistoryEvent extends HistoryEvent {}

/// Event to fetch a specific session detail
class FetchSessionDetailEvent extends HistoryEvent {
  final String sessionId;

  FetchSessionDetailEvent(this.sessionId);
}

/// Event to refresh the session list
class RefreshHistoryEvent extends HistoryEvent {}

