import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:RESTAPI/globals.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final Errors error;

  const LoginInitial({this.error});

  @override
  List<Object> get props => [error];

}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class SignUpInitial extends LoginState{
  final String error;

  const SignUpInitial({this.error});

  @override 
  List<Object> get props => [error];
}