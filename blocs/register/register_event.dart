import 'package:RESTAPI/globals.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  const RegisterButtonPressed({
    @required this.name,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [name, email, password];

  @override
  String toString() =>
      'LoginButtonPressed { name: $name, username: $email, password: $password }';
}

class RegisterFailed extends RegisterEvent{
  final Errors error;

  const RegisterFailed({
    @required this.error
  });

  @override
  List<Object> get props => [error];
}

class RegisterSuccess extends RegisterEvent{
  final String name;
  final String email;
  final String password;
  final String token;

  const RegisterSuccess({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.token
  });

   @override
  List<Object> get props => [name, email, password, token];
}

class Login extends RegisterEvent{

  @override
  List<Object> get props => [];
}