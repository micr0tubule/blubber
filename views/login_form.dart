

import '../blocs/authentication/user_repository.dart';
import '../blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:RESTAPI/styles.dart';
import '../blocs/login/login_event.dart';
import 'package:email_validator/email_validator.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/globals.dart' as globals;

  class LoginForm extends StatefulWidget {
    final globals.Errors error;

    LoginForm({
      Key key, this.error
    }) : super(key: key);

    @override
    State<LoginForm> createState() => _LoginFormState(error: this.error);
  }

  class _LoginFormState extends State<LoginForm> {
    final LoginBloc _loginBloc = globals.loginBloc;
    final UserRepository userRepository = UserRepository();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    List<bool> passwordValidations = [true, true, true, true, true, true];
    bool emailValidation = true;
    bool emailIsEmpty = true;
    final globals.Errors error;

    _LoginFormState({this.error});

    @override
    Widget build(BuildContext context) {

      return Scaffold( 
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colorrs.loginPageBackground,
        body: Stack(
          children: [
            Positioned( 
              top: 140,
              left: 60,
              child: Text( 
                'hello.',
                style: Styles.loginHeader
              )
            ),
            Center(
              child: Container(
                width: 300,
                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/2.6, 0, 0),
                child: Column(  
                  children: [
                    Container(
                      decoration: BoxDecoration( 
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                      ),
                      padding: EdgeInsets.all(Sizes.loginPaddingAll),
                      child: SizedBox(  
                        width: 360,
                        child: TextField(
                          cursorColor: HexColor.fromHex(HexCodes.main),
                          style: Styles.text,
                          textAlign: TextAlign.center,
                          controller: _emailController,  
                          decoration: InputDecoration(  
                              focusedBorder: OutlineInputBorder(  
                              borderSide: BorderSide(  
                                color: Colorrs.loginInputBorder
                              )
                            ),
                            hintText: 'email',
                            hintStyle: TextStyle( 
                              color: emailIsEmpty ? Colorrs.loginInputHint : Colorrs.missingInput,
                              fontSize: Sizes.loginInputHint, 
                              fontFamily: Fonts.standard
                              )
                          ),
                          minLines: 1,
                          maxLines: 1,
                        )
                      )
                    ),  
                    SizedBox(height: 20),
                    Container( // password input field 
                      padding: EdgeInsets.all(Sizes.loginPaddingAll),
                      decoration: BoxDecoration( 
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                      ),
                      child: SizedBox(  
                        width: 360,
                        child: TextField(
                          cursorColor: HexColor.fromHex(HexCodes.main),
                          style: Styles.text,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          controller: _passwordController,  
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(  
                              borderSide: BorderSide(  
                                color: Colorrs.loginInputBorder
                              )
                            ),
                            hintText: 'password',
                            hintStyle: TextStyle(  
                              color: this.passwordValidations[0] ? Colorrs.loginInputHint : Colorrs.missingInput,
                              fontSize: Sizes.loginInputHint, 
                              fontFamily: Fonts.standard
                            )
                          ),
                          minLines: 1,
                          maxLines: 1,
                        )
                      )
                    ),
                    SizedBox(height: 20),
                    InkWell( 
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _onLoginButtonPressed,
                      child: Container( 
                        width: 360,
                        height: 58,
                        decoration: BoxDecoration( 
                          color: Colorrs.loginButton,
                          // color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                        ),
                        padding: EdgeInsets.all(Sizes.loginPaddingAll),
                        child: Center( 
                          child: Text(  
                            'login', 
                            style: Styles.loginButton,
                          ),
                        )
                      )
                    ),
                    error == globals.Errors.EMAIL_NOT_FOUND_OR_WRONG_PASSWORD ? Container(  
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'email not registered or wrong password :)',
                        style: Styles.errorMessage
                      ),
                    ) : Container(),
     
                  ]
                )
              )
            ),
              Align(  
                alignment: FractionalOffset.bottomRight,
                child: Container(  
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: (){
                      _loginBloc.add(SignUp());
                      _onLoginButtonPressed();
                    },  
                    child: Text(  
                      'signup',
                      style: Styles.loginSwitchButton,
                    ),
                  )
                )
              ),
              Align(  
              alignment: FractionalOffset.bottomLeft,
              child: Container(  
                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (){
                    _onOfflineButtonPressed();
                  },  
                  child: Text(  
                    'offline',
                    style: Styles.loginSwitchButton,
                  ),
                )
              )
            )
        
          
          ],
        ),
      );
  
    }

    // void _onWidgetDidBuild(Function callback) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     callback();
    //   });
    // }

    _onLoginButtonPressed() {
      setState(() {
        this.passwordValidations = validatePassword(_passwordController.text);
        this.emailValidation = EmailValidator.validate(_emailController.text);
        this.emailIsEmpty = _emailController.text.isNotEmpty;
      });
      if(passwordValidations[0] != false && emailIsEmpty){  
        _loginBloc.add(LoginButtonPressed(
          email: _emailController.text,
          password: _passwordController.text,
        ));
        // ));
        Service server = Service();
        server.login(_emailController.text, _passwordController.text).then((value){
          if(value.message == '0'){
            // globals.authenticationBloc.add(LoggedIn(email: _emailController.text, password:  _passwordController.text, token: value.token));
            globals.loginBloc.add(LoginSuccess(email: _emailController.text, password: _passwordController.text, token: value.token));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => Root()));
          } 
          else if(value.message == '1'){
            globals.loginBloc.add(LoginFailed(error: globals.Errors.EMAIL_NOT_FOUND_OR_WRONG_PASSWORD));
        
          }else{
            print(value.message);
          }
        });
      }
    }
    
    _onOfflineButtonPressed(){
      userRepository.setOffline().then((value) {

        _loginBloc.add(OfflineButtonPressed());
      });
    }

    List<bool> validatePassword(String password){
      List<bool> validations = [
        false, // check if password is empty
        false, // check if password contains upper case letter
        false, // check if password contains lower case letter
        false, // check if password contains digit 
        false, // check if password contains special char
        false  // check if password is min 8 chars long
      ];
      Pattern upperCasePattern = r'^(?=.*?[A-Z])';
      Pattern lowerCasePattern = r'(?=.*?[a-z])';
      Pattern oneDigitPattern = r'(?=.*?[0-9])'; 
      Pattern oneSpecialPattern = r'(?=.*?[!@#\$&*~])';
      Pattern charsCountPattern = r'.{8,}$';

      RegExp upperCase = RegExp(upperCasePattern);
      RegExp lowerCase = RegExp(lowerCasePattern);
      RegExp oneDigit = RegExp(oneDigitPattern);
      RegExp oneSpecial = RegExp(oneSpecialPattern);
      RegExp charsCount = RegExp(charsCountPattern);

      if(_passwordController.text.isNotEmpty){
        validations[0] = true;
      }
      if(upperCase.hasMatch(password)){
        validations[1] = true;
      }
      if(lowerCase.hasMatch(password)){
        validations[2] = true;
      }
      if(oneDigit.hasMatch(password)){
        validations[3] = true;
      }
      if(oneSpecial.hasMatch(password)){
        validations[4] = true;
      }
      if (charsCount.hasMatch(password)){
        validations[5] = true;
      }
      return validations;
    }
  }


  // Our LoginForm uses the BlocBuilder widget so that it can rebuild whenever there is a new LoginState.
  //
  // BlocBuilder is a Flutter widget which requires a Bloc and a builder function. 
  // BlocBuilder handles building the widget in response to new states. BlocBuilder is very similar 
  // to StreamBuilder but has a more simple API to reduce the amount of boilerplate code needed.
  //
  // There’s not much else going on in the LoginForm widget so let’s move on to creating our loading indicator.