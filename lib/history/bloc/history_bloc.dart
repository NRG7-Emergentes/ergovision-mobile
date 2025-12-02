import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ergovision/history/bloc/history_event.dart';
import 'package:ergovision/history/bloc/history_state.dart';
import 'package:ergovision/history/services/history_service.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryService historyService;

  HistoryBloc({required this.historyService}) : super(HistoryInitial()) {
    on<FetchHistoryEvent>(_onFetchHistory);
    on<FetchSessionDetailEvent>(_onFetchSessionDetail);
    on<RefreshHistoryEvent>(_onRefreshHistory);
  }

  /// Handle fetching all sessions
  Future<void> _onFetchHistory(
    FetchHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      print('=== HISTORY BLOC - Fetching Sessions ===');
      final sessions = await historyService.listSessions();
      print('✅ Sessions loaded successfully: ${sessions.length}');
      emit(HistoryLoaded(sessions));
    } catch (e) {
      print('❌ Error loading sessions: $e');
      emit(HistoryError('Failed to load sessions: $e'));
    }
  }

  /// Handle fetching session detail
  Future<void> _onFetchSessionDetail(
    FetchSessionDetailEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      print('=== HISTORY BLOC - Fetching Session Detail: ${event.sessionId} ===');
      final session = await historyService.getSession(event.sessionId);

      if (session != null) {
        print('✅ Session detail loaded successfully');
        emit(SessionDetailLoaded(session));
      } else {
        print('❌ Session not found');
        emit(HistoryError('Session not found'));
      }
    } catch (e) {
      print('❌ Error loading session detail: $e');
      emit(HistoryError('Failed to load session detail: $e'));
    }
  }

  /// Handle refreshing session list
  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    // Don't emit loading state for refresh to avoid UI flicker
    try {
      print('=== HISTORY BLOC - Refreshing Sessions ===');
      final sessions = await historyService.listSessions();
      print('✅ Sessions refreshed successfully: ${sessions.length}');
      emit(HistoryLoaded(sessions));
    } catch (e) {
      print('❌ Error refreshing sessions: $e');
      emit(HistoryError('Failed to refresh sessions: $e'));
    }
  }
}

