
import 'dart:async';
import 'package:RESTAPI/services/service.dart';
import 'package:bloc/bloc.dart';
import '../authentication/user_repository.dart';
import '../authentication/authentication_bloc.dart';
import 'register_state.dart';
import 'register_event.dart';
import '../authentication/authentication_event.dart';
import 'package:RESTAPI/globals.dart' as globals;

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final Service server = Service();
  final AuthenticationBloc authenticationBloc;

  RegisterBloc({
    this.userRepository,
    this.authenticationBloc,
  })  : super(RegisterInitial());

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    try{
      print(event.toString());
      if (event is RegisterButtonPressed) {
        yield RegisterLoading();
      }
      else if (event is RegisterFailed){
        yield RegisterInitial(error: event.error);
      }
      else if (event is RegisterSuccess){
        globals.authenticationBloc.add(LoggedIn(email: event.email, password: event.password, token: event.token));
        yield RegisterInitial();
      }
      else if (event is Login){
        globals.authenticationBloc.add(AppStarted());
      }
    } catch (error){
        yield RegisterFailure(error: error.toString());
    }
  }
  void dispose(){
    // close();
  }
}