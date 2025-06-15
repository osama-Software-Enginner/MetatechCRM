import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>(_onStartSplash);
  }

  Future<void> _onStartSplash(StartSplash event, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    // Simulate a delay for the splash screen (e.g., 3 seconds)
    await Future.delayed(const Duration(seconds: 5));
    emit(SplashCompleted());
  }
}