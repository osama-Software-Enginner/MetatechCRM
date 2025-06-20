import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginEvent.dart';
import 'LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  // void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try {
  //     // Simulate dummy login
  //     await Future.delayed(const Duration(seconds: 1));
  //     if (event.email == 'test@metatech.com' && event.password == 'password123') {
  //       emit(LoginSuccess());
  //     } else {
  //       emit(const LoginFailure('Invalid email or password'));
  //     }
  //   } catch (e) {
  //     emit(LoginFailure('Login failed: $e'));
  //   }
  // }
  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Simulate dummy login
      await Future.delayed(const Duration(seconds: 1));
      if (event.email == 'test@metatech.com' && event.password == 'password123') {
        // ✅ Save session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_email', event.email); // optional

        emit(LoginSuccess());
      } else {
        emit(const LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure('Login failed: $e'));
    }
  }

}