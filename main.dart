import 'package:flutter/material.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';
import 'blocs/authentication/authentication_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/splash_page.dart';
import 'models/root.dart';
import 'views/login.dart';
import 'views/loading_indicator.dart';
import 'globals.dart' as globals;
import 'storage.dart' as storage;
import 'dart:async';

void main() {
  Timer.periodic(storage.updateDuration, (Timer t) => storage.updateServerStorage());
  runApp(App());
}

class App extends StatefulWidget {

  @override
  State<App> createState() => _AppState();

  App({Key key}) : super(key: key);
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    authenticationBloc = globals.authenticationBloc;
    authenticationBloc.add(AppStarted());
    super.initState();
  }

  // @override
  // void dispose() {
  //   authenticationBloc.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (BuildContext context) => authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashPage();
            }
            if (state is AuthenticationAuthenticated) {
              return Root();
            }
            if (state is AuthenticationUnauthenticated) {
              return Login();
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
            if (state is NewAuthentication){
              return Login();
            }
            return Container();
          },
        ),
      ),
    );
  }
}