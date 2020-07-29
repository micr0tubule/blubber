import 'package:RESTAPI/blocs/login/login_event.dart';
import '../blocs/authentication/user_repository.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:flutter/material.dart';
import 'package:RESTAPI/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:RESTAPI/globals.dart' as globals;

  class RegisterForm extends StatefulWidget {

    RegisterForm({ Key key }) : super(key: key);

    @override
    State<RegisterForm> createState() => _RegiserFormState();
  }

  class _RegiserFormState extends State<RegisterForm> {
    final UserRepository userRepository = UserRepository(); 
    final _loginBloc = globals.loginBloc;
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _passwordConfirmController = TextEditingController();
    List<bool> passwordValidations = [true, true, true, true, true, true, true];
    bool emailValidation = true;
    bool emailIsNotEmpty = true;
    bool nameIsEmpty = true;
    bool passwordConfirmIsEmpty = true;
    bool nameValidation = true;
    globals.Errors error;

    _RegiserFormState(){
      _nameController.text = '';
      _emailController.text = '';
      
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold( 
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colorrs.loginPageBackground,
            body: Stack(
              
              children: [
                        error == globals.Errors.EMAIL_IN_USE ? Container(  
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            'email already in use',
                            style: Styles.errorMessage
                          ),
                        ) : Container(),
                        (passwordValidations[0] || emailIsNotEmpty || nameIsEmpty || passwordConfirmIsEmpty) ? Container( 
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(  
                            children: [  
                              !emailValidation && emailIsNotEmpty ? Container(  
                                child: Text(
                                  '- invalid email',
                                  style: Styles.errorMessage
                                ),
                              ) : Container(),
                              passwordValidations.contains(false) ? Column(
                                children: [
                                 
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text( 
                                      'a strong password needs to contain:',
                                      style: Styles.errorMessage,
                                    ),
                                  ),
                                  !passwordValidations[1] ? Text(
                                    '- at least one upper case letter',
                                    style: Styles.errorMessage,
                                  ) : Container(),
                                  !passwordValidations[2] ? Text( 
                                    '- at least one lower case letter',
                                    style: Styles.errorMessage,
                                  ) : Container(),
                                  !passwordValidations[3] ? Text( 
                                    '- at least one digit',
                                    style: Styles.errorMessage,
                                  ) : Container(),
                                  !passwordValidations[4] ? Text( 
                                    '- at least one special character',
                                    style: Styles.errorMessage,
                                  ) : Container(),
                                  !passwordValidations[5] ? Text( 
                                    '- at least 8 characters',
                                    style: Styles.errorMessage,
                                    textAlign: TextAlign.left,
                                  ) : Container(),                              
                                ]
                              ) : !passwordValidations[6] ? Text( 
                                    '- passwords are not the same',
                                    style: Styles.errorMessage,
                                    textAlign: TextAlign.left,
                                  ) : Container(),
                            ],
                          ),
                        ) : Container(),
                Positioned( 
                  top: 140,
                  left: 60,
                  child: Text( 
                    'welcome.',
                    style: Styles.loginHeader
                  )
                ),
                Center(
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/3.4, 0, 0),
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
                              controller: _nameController,  
                              decoration: InputDecoration(  
                                 focusedBorder: OutlineInputBorder(  
                                  borderSide: BorderSide(  
                                    color: Colorrs.loginInputBorder
                                  )
                                ),
                                hintText: 'name',
                                hintStyle: TextStyle( 
                                  color: nameIsEmpty ? Colorrs.loginInputHint : Colorrs.missingInput,
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
                        Container( // name input field 
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
                                  color: emailIsNotEmpty ? Colorrs.loginInputHint : Colorrs.missingInput,
                                  fontSize: Sizes.loginInputHint, 
                                  fontFamily: Fonts.standard
                                 )
                              ),
                            )
                          )
                        ),
                        SizedBox(height: 20),
                        Container( // email input field 
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
                              obscureText: true,
                              textAlign: TextAlign.center,
                              controller: _passwordController,  
                              decoration:  InputDecoration(
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
                       Container( // email input field 
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
                              controller: _passwordConfirmController,  
                              decoration:  InputDecoration(
                                focusedBorder: OutlineInputBorder(  
                                  borderSide: BorderSide(  
                                    color: Colorrs.loginInputBorder
                                  )
                                ),
                                hintText: 'confirm',
                                hintStyle: TextStyle(  
                                  color: this.passwordConfirmIsEmpty ? Colorrs.loginInputHint : Colorrs.missingInput,
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
                          onTap: _onRegisterButtonPressed,
                          child: Container( 
                            height: 58,
                            padding: EdgeInsets.all(Sizes.loginPaddingAll),
                            decoration: BoxDecoration( 
                              color: Colorrs.loginButton,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                            ),
                            child: Center(
                              child: Text(  
                                'signup',
                                style: Styles.loginButton
                              )
                            )
                          )
                        ),

                      ]
                    )
                  )
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(  
                    child: MaterialButton(
                      highlightColor: Colors.transparent,       
                      splashColor: Colors.transparent,
                      onPressed: (){
                        globals.loginBloc.add(LoginFailed(error: null));
                      },  
                      child: Text(  
                        'login',
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

    _onRegisterButtonPressed() {
      setState(() {
        validateName();
        validatePassword();
        validateEmail();
      });
      if(!passwordValidations.contains(false) && emailValidation){
        _loginBloc.add(SignUpButtonPressed(name: _nameController.text, 
                                           email: _emailController.text, 
                                           password: _passwordConfirmController.text));
        Service server = Service();
        server.signup(_nameController.text, _emailController.text, _passwordConfirmController.text).then((value){
        if (value.message == '0'){
          print('ok');
          // _registerBloc.add(RegisterSuccess(name: _nameController.text, email: _emailController.text, password: _passwordConfirmController.text));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Root())); // bacause i dont know why register bloc doesnt do it
          print(value.token);
          globals.loginBloc.add(LoginSuccess(email: _emailController.text, password: _passwordConfirmController.text, token: value.token));
          userRepository.signup(name: _nameController.text, email: _emailController.text, password: _passwordConfirmController.text, token: value.token);
        }
        else if (value.message == '1'){
          print('ok2');
          
          _loginBloc.add(LoginFailed(error: globals.Errors.EMAIL_IN_USE));
        }
        else{
          print(value.message);
        }
      });  
      }
    }

    void validatePassword(){
      String password = _passwordController.text;
      String passwordConfirmation = _passwordConfirmController.text;

      this.passwordValidations = [
        false, // check if password is empty
        false, // check if password contains upper case letter
        false, // check if password contains lower case letter
        false, // check if password contains digit
        false, // check if password contains special char
        false, // check if password is min 8 chars long
        false  // check if password and password confirmation are the same
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

      if(password.isNotEmpty){
        this.passwordValidations[0] = true;
      }
      if(upperCase.hasMatch(password)){
        this.passwordValidations[1] = true;
      }
      if(lowerCase.hasMatch(password)){
        this.passwordValidations[2] = true;
      }
      if(oneDigit.hasMatch(password)){
        this.passwordValidations[3] = true;
      }
      if(oneSpecial.hasMatch(password)){
        this.passwordValidations[4] = true;
      }
      if (charsCount.hasMatch(password)){
        this.passwordValidations[5] = true;
      }
      if (password == passwordConfirmation){
        this.passwordValidations[6] = true;
      }
      
      passwordConfirmIsEmpty = _passwordConfirmController.text.isNotEmpty;
    }
    
    void validateName(){
      this.nameIsEmpty = _nameController.text.isNotEmpty;
      if (this._nameController.text.length >= 3){
        this.nameValidation = true;
      } else{  
        this.nameValidation = false;
      }
    }

    void validateEmail(){
      this.emailIsNotEmpty = _emailController.text.isNotEmpty;
      this.emailValidation = EmailValidator.validate(_emailController.text);
    }
  }

