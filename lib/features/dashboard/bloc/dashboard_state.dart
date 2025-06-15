import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String clientName;
  final List<Map<String, dynamic>> graphData;
  final List<Map<String, dynamic>> sdlcStages; // Added for SDLC

  const DashboardLoaded({
    required this.clientName,
    required this.graphData,
    required this.sdlcStages,
  });

  @override
  List<Object> get props => [clientName, graphData, sdlcStages];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}