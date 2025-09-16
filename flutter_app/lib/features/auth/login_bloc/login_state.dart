import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool loading;
  final String? error;
  final bool success;

  const LoginState({
    this.email = '',
    this.password = '',
    this.loading = false,
    this.error,
    this.success = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? loading,
    String? error,     // مرر null لمسح الخطأ
    bool? success,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [email, password, loading, error, success];
}
