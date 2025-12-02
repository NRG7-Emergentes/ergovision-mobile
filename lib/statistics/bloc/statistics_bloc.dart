import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ergovision/statistics/bloc/statistics_event.dart';
import 'package:ergovision/statistics/bloc/statistics_state.dart';
import 'package:ergovision/statistics/models/statistics.dart';
import 'package:ergovision/statistics/services/statistics_service.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsService statisticsService;

  StatisticsBloc({required this.statisticsService}) : super(StatisticsInitial()) {
    on<LoadStatisticsEvent>(_onLoadStatistics);
    on<RefreshStatisticsEvent>(_onRefreshStatistics);
  }

  void _onLoadStatistics(
    LoadStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());
    try {
      // El backend obtiene el userId del token de autenticación
      print('🔍 [Statistics] Cargando estadísticas...');
      final response = await statisticsService.getStatistics();

      print('📊 [Statistics] Status Code: ${response.statusCode}');
      print('📄 [Statistics] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final statistics = Statistics.fromJson(json.decode(response.body));
        print('✅ [Statistics] Datos cargados exitosamente');
        emit(StatisticsSuccess(statistics));
      } else {
        final errorMsg = 'Error ${response.statusCode}: ${response.body}';
        print('❌ [Statistics] $errorMsg');
        emit(StatisticsError(errorMsg));
      }
    } catch (e) {
      print('💥 [Statistics] Exception: $e');
      emit(StatisticsError('Error loading statistics: $e'));
    }
  }

  void _onRefreshStatistics(
    RefreshStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    // No emitir loading si ya hay datos cargados
    try {
      final response = await statisticsService.getStatistics();

      if (response.statusCode == 200) {
        final statistics = Statistics.fromJson(json.decode(response.body));
        emit(StatisticsSuccess(statistics));
      } else {
        emit(StatisticsError('Failed to refresh statistics: ${response.statusCode}'));
      }
    } catch (e) {
      emit(StatisticsError('Error refreshing statistics: $e'));
    }
  }
}

