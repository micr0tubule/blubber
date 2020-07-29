
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../authentication/user_repository.dart';
import 'login_state.dart';
import 'login_event.dart';
import '../authentication/authentication_event.dart' as auth;
import 'package:RESTAPI/globals.dart' as globals;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository = UserRepository();

  LoginBloc() : super(LoginInitial());

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    print(event.toString());
    if (event is LoginButtonPressed) {
      yield LoginLoading();
    }
    else if (event is LoginFailed){
      yield LoginInitial(error: event.error);
    }
    else if (event is LoginSuccess){
      globals.authenticationBloc.add(auth.LoggedIn(email: event.email, password: event.password, token: event.token));
    }
    else if (event is SignUp){
      yield SignUpInitial();
    }
    else if (event is SignUpButtonPressed){
      yield LoginLoading();
    }
    else{
      yield LoginInitial(error: globals.Errors.SOMETHING_ELSE);
    }
    if (event is OfflineButtonPressed) {
      globals.authenticationBloc.add(auth.Offline());
    }

  }
  void dispose(){
    // close();
  }
}