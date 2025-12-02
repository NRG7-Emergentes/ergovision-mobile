import 'package:ergovision/statistics/models/statistics.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsSuccess extends StatisticsState {
  final Statistics statistics;

  StatisticsSuccess(this.statistics);
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}

