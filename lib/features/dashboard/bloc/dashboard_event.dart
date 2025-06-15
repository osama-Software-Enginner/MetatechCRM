import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class ToggleEmirate extends DashboardEvent {
  final String emirate;

  const ToggleEmirate(this.emirate);

  @override
  List<Object> get props => [emirate];
}