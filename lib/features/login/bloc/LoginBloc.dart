import 'package:flutter_bloc/flutter_bloc.dart';

import 'LoginEvent.dart';
import 'LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Simulate dummy login
      await Future.delayed(const Duration(seconds: 1));
      if (event.email == 'test@metatech.com' && event.password == 'password123') {
        emit(LoginSuccess());
      } else {
        emit(const LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure('Login failed: $e'));
    }
  }
}