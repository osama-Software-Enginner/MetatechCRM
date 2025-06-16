import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<ToggleEmirate>(_onToggleEmirate);
  }

  Future<void> _onLoadDashboard(
      LoadDashboard event, Emitter<DashboardState> emit) async {
    print('Emitting DashboardLoading'); // Debug log
    emit(DashboardLoading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate data fetch
      final clientName = "Ali";
      final graphData = [
        {"name": "Dubai", "value": 75.0},
        {"name": "Sharjah", "value": 50.0},
        {"name": "Abu Dhabi", "value": 90.0},
        {"name": "RAK", "value": 30.0},
      ];
      final sdlcStages = [
        {"name": "Planning", "completed": true},
        {"name": "Design", "completed": true},
        {"name": "Development", "completed": false},
        {"name": "Testing", "completed": false},
        {"name": "Deployment", "completed": false},
      ];
      final campaignTimeSeriesData = [
        {
          "emirate": "Dubai",
          "leads": [28.0, 29.0, 30.0, 31.0, 30.0, 32.0],
          "impressions": [280.0, 290.0, 300.0, 310.0, 300.0, 320.0],
        },
        {
          "emirate": "Sharjah",
          "leads": [9.0, 10.0, 10.0, 11.0, 10.0, 10.0],
          "impressions": [90.0, 100.0, 100.0, 110.0, 100.0, 100.0],
        },
        {
          "emirate": "Abu Dhabi",
          "leads": [48.0, 49.0, 50.0, 51.0, 50.0, 52.0],
          "impressions": [480.0, 490.0, 500.0, 510.0, 500.0, 520.0],
        },
        {
          "emirate": "Ajman",
          "leads": [4.0, 5.0, 5.0, 5.0, 5.0, 6.0],
          "impressions": [40.0, 50.0, 50.0, 50.0, 50.0, 60.0],
        },
        {
          "emirate": "Ras Al Khaimah",
          "leads": [6.0, 7.0, 7.0, 7.0, 7.0, 8.0],
          "impressions": [60.0, 70.0, 70.0, 70.0, 70.0, 80.0],
        },
        {
          "emirate": "Umm Al Quwain",
          "leads": [0.5, 1.0, 1.0, 1.0, 1.0, 1.5],
          "impressions": [5.0, 10.0, 10.0, 10.0, 10.0, 15.0],
        },
      ];
      if (isClosed) return; // Prevent emission if BLoC is closed
      print('Emitting DashboardLoaded'); // Debug log
      emit(DashboardLoaded(
        clientName: clientName,
        graphData: graphData,
        sdlcStages: sdlcStages,
        campaignTimeSeriesData: campaignTimeSeriesData,
        visibleEmirates: ['Dubai', 'Abu Dhabi', 'Sharjah'],
      ));
    } catch (e, stackTrace) {
      print('Error in _onLoadDashboard: $e\n$stackTrace'); // Debug log
      if (isClosed) return;
      emit(DashboardError("Failed to load dashboard: $e"));
    }
  }

  void _onToggleEmirate(ToggleEmirate event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newVisibleEmirates = List<String>.from(currentState.visibleEmirates);
      if (newVisibleEmirates.contains(event.emirate)) {
        newVisibleEmirates.remove(event.emirate);
      } else {
        newVisibleEmirates.add(event.emirate);
      }
      if (isClosed) return;
      print('Toggling emirate: ${event.emirate}'); // Debug log
      emit(DashboardLoaded(
        clientName: currentState.clientName,
        graphData: currentState.graphData,
        sdlcStages: currentState.sdlcStages,
        campaignTimeSeriesData: currentState.campaignTimeSeriesData,
        visibleEmirates: newVisibleEmirates,
      ));
    }
  }
}