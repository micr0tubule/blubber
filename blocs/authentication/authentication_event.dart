import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String email;
  final String password;
  final String token;

  LoggedIn({@required this.email, @required this.password, @required this.token}) : super([email, password, token]);

  @override
  List<Object> get props => [email, password, token];

  @override
  String toString() => 'LoggedIn { email: $email password $password }';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  List<Object> get props => [];
}

class SignUp extends AuthenticationEvent{
  @override
  String toString() => 'SignUp';

  List<Object> get props => [];
}

class Offline extends AuthenticationEvent{ 
  List<Object> get props => [];
}




