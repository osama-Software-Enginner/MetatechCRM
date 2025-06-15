abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String clientName;
  final List<Map<String, dynamic>> graphData; // Added for graph

  DashboardLoaded({required this.clientName, required this.graphData});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}