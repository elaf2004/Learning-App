
import 'package:equatable/equatable.dart';

  abstract class SingupEvent extends Equatable{
  const SingupEvent();
  @override
  List<Object?> get props => [];

}
class SingupNameChanged extends SingupEvent{
  final String name;
  const SingupNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class SingupEmailChanged extends SingupEvent{
  final String email;
  const SingupEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class SingupPasswordChanged extends SingupEvent{
  final String password;
  const SingupPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class SingupPasswordConfirmChanged extends SingupEvent{
  final String password;
  const SingupPasswordConfirmChanged(this.password);
  @override
  List<Object?> get props => [password];
}



class SingupSubmitted extends SingupEvent{
  const SingupSubmitted();
}

