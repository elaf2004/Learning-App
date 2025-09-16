import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;
  LoginBloc(this.repo) : super(const LoginState()) {
    on<LoginEmailChanged>((e, emit) {
      emit(state.copyWith(email: e.email, error: null, success: false));
    });

    on<LoginPasswordChanged>((e, emit) {
      emit(state.copyWith(password: e.password, error: null, success: false));
    });

    on<LoginSubmitted>((e, emit) async {
      if (state.email.isEmpty || state.password.isEmpty) {
        emit(state.copyWith(error: 'Email/Password required'));
        return;
      }
      emit(state.copyWith(loading: true, error: null, success: false));
      try {
        await repo.login(state.email, state.password);
        emit(state.copyWith(loading: false, success: true));
      } catch (err) {
        print('Login error: $err');
        emit(state.copyWith(loading: false, error: err.toString()));
      }
    });
  }
}
