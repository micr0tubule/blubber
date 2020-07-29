import 'dart:async';
import 'package:RESTAPI/services/service.dart';
import 'package:bloc/bloc.dart';
import 'user_repository.dart';
import 'authentication_state.dart';
import 'authentication_event.dart';
import 'package:RESTAPI/storage.dart' as storage;
import 'package:RESTAPI/globals.dart' as globals;
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  final UserRepository userRepository = UserRepository();    
  AuthenticationBloc() : super(AuthenticationUninitialized());


  @override
  AuthenticationState get initialState => AuthenticationUninitialized();
  Service server = Service();

  @override
  Stream<AuthenticationState> mapEventToState(
    // AuthenticationState currentState,
    AuthenticationEvent event,
  ) async* {
    print(event.toString());
    if (event is AppStarted) {
      final String token = await userRepository.getToken();

      if (token == 'Gertrude'){
        yield AuthenticationAuthenticated();

        userRepository.setOffline().then((value) {
          globals.load();

        });
      }
      else if (token != null) {
        await server.updateToken().then((value) {
          globals.load();
        });
        // storage.compareNotes();
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      globals.token = event.token;
      await userRepository.persistToken(event.email, event.password, event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();

      storage.deleteData();
      yield AuthenticationUnauthenticated();
    }

    if (event is SignUp){
      yield NewAuthentication();
    }

    if (event is Offline){ 
      await userRepository.setOffline();
      yield AuthenticationAuthenticated();
    }
  }

  void dispose(){
  }
}

