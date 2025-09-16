
import 'package:equatable/equatable.dart';

class SingupState extends Equatable {

  final String name;
  final String email;
  final String password;
  final String passwordConfirm;
  final bool loading;
  final String? error;
  final bool success;
  const SingupState({
    this.name='',
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.loading = false,
    this.error,
    this.success = false,
  });

  SingupState copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirm,
    bool? loading,
    String? error,     
    bool? success,
  }) {
    return SingupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
    );
  }
  
  @override
  @override
List<Object?> get props => [
      name,
      email,
      password,
      passwordConfirm,
      loading,
      error,
      success,
    ];

}