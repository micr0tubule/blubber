import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:RESTAPI/globals.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $email, password: $password }';
}

class LoginFailed extends LoginEvent{
  final Errors error;

  const LoginFailed({@required this.error});

  @override
  List<Object> get props => [error];

}

class LoginSuccess extends LoginEvent{
  final String email; 
  final String password;
  final String token;

  const LoginSuccess({
    @required this.email,
    @required this.password,
    @required this.token
  });

  @override
  List<Object> get props => [email, password, token];
}

class SignUp extends LoginEvent{
  
  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends LoginEvent{
  final String name;
  final String email;
  final String password;

  const SignUpButtonPressed({
    @required this.name,
    @required this.email,
    @required this.password,
  });

  @override  
  List<Object> get props => [name, email, password];
}

class OfflineButtonPressed extends LoginEvent{ 
  final String name = 'Gertrude';
  final String email = 'Gertrude@Gertrude.com';
  final String password = 'Gertrude69';

  @override
  List<Object> get props => [name, email, password];
  
}