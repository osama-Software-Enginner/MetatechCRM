import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      final clientName = "John Doe"; // Replace with actual data
      final graphData = [
        {"name": "Project A", "value": 75.0},
        {"name": "Project B", "value": 50.0},
        {"name": "Project C", "value": 90.0},
        {"name": "Project D", "value": 30.0},
      ];
      emit(DashboardLoaded(clientName: clientName, graphData: graphData));
    } catch (e) {
      emit(DashboardError("Failed to load dashboard: $e"));
    }
  }
}