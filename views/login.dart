import 'package:RESTAPI/views/login_form.dart';
import  'package:flutter/material.dart';
import '../blocs/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'register_form.dart';
import 'package:RESTAPI/styles.dart';
class Login extends StatefulWidget {

  Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: globals.loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
        }
        if (state is SignUpInitial){
          return RegisterForm();
        }
        if (state is LoginInitial){
          return LoginForm(error: state.error);
        }
        if (state is LoginLoading){
          return Scaffold(
            backgroundColor: Colorrs.background,
            body: Center(child: CircularProgressIndicator())
          );
        }
        return Container();
      } 
    );
  }

  @override
  void dispose() {
    globals.loginBloc.dispose();
    super.dispose();
  }
}
// this class is actually not needed anymore