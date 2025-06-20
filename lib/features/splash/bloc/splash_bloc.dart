import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>(_onStartSplash);
  }

  Future<void> _onStartSplash(StartSplash event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      emit(SplashNavigateToDashboard());
      print(isLoggedIn);
    } else {
      emit(SplashNavigateToLogin());
    }
  }

}