import 'package:RESTAPI/globals.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final Errors error;

  RegisterInitial({this.error});

  @override
  List<Object> get props => [error];
}

class RegisterLoading extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RegisterFailure { error: $error }';
}