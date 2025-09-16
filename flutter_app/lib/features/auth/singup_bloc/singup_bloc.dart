import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/singup_bloc/singup_event.dart';
import 'package:app/features/auth/singup_bloc/singup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingupBloc extends Bloc<SingupEvent, SingupState> {
  final AuthRepository repo;
  SingupBloc(this.repo) : super(const SingupState()) {
    on<SingupNameChanged>((e, emit) {
      emit(state.copyWith(name: e.name, error: null, success: false));
    });

    on<SingupEmailChanged>((e, emit) {
      emit(state.copyWith(email: e.email, error: null, success: false));
    });

    on<SingupPasswordChanged>((e, emit) {
      emit(state.copyWith(password: e.password, error: null, success: false));
    });

    on<SingupPasswordConfirmChanged>((e, emit) {
      emit(state.copyWith(passwordConfirm: e.password, error: null, success: false));
    });

    on<SingupSubmitted>((e, emit) async {
      if (state.email.isEmpty ||
          state.password.isEmpty ||
          state.name.isEmpty ||
          state.passwordConfirm.isEmpty) {
        emit(state.copyWith(error: 'Name/Email/Password required'));
        return;
      }

      emit(state.copyWith(loading: true, error: null, success: false));

      try {
        final response = await repo.signup(
          state.name,
          state.email,
          state.password,
          state.passwordConfirm,
        );

        // التحقق من نجاح التسجيل
        if (response['status'] == true) {
          emit(state.copyWith(loading: false, success: true));
        } else {
          emit(state.copyWith(
            loading: false,
            error: response['message'] ?? 'Signup failed',
          ));
        }
      } catch (err) {
        print('Singup error: $err');
        emit(state.copyWith(loading: false, error: err.toString()));
      }
    });
  }
}
