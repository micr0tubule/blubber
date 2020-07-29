import 'package:RESTAPI/blocs/login/login_event.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/user_repository.dart';
import '../blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import '../styles.dart';
import '../models/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:RESTAPI/storage.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'dart:math' as math;
import 'standardWidgets/OnOffSetting.dart';
import 'standardWidgets/ButtonSetting.dart';

class ColorSettings extends StatefulWidget {
  final Note note;
  final Note noteCopy;
  final Function setDisplayState;

  ColorSettings(this.note, this.noteCopy, this.setDisplayState);
  @override
  _ColorSettingsState createState() =>
      _ColorSettingsState(this.note, this.noteCopy, this.setDisplayState);
}

class _ColorSettingsState extends State<ColorSettings> {
  Note note;
  Note noteCopy;
  final Function setDisplayState;

  _ColorSettingsState(this.note, this.noteCopy, this.setDisplayState);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                width: 55,
                padding: EdgeInsets.fromLTRB(6, 0, 7, 0),
                child: FlatButton(
                    onPressed: () {
                      this.noteCopy.color = HexCodes.main;
                    },
                    color: HexColor.fromHex(HexCodes.main),
                    shape: CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              Container(
                width: 55,
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: FlatButton(
                    onPressed: () {
                      this.noteCopy.color = HexCodes.mainContrast;
                    },
                    color: HexColor.fromHex(HexCodes.mainContrast),
                    shape: CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              Container(
                width: 57,
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: FlatButton(
                    onPressed: () {
                      this.noteCopy.color = HexCodes.secondary;
                    },
                    color: HexColor.fromHex(HexCodes.secondary),
                    shape: CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              Container(
                width: 55,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: FlatButton(
                    onPressed: () {
                      this.noteCopy.color = HexCodes.secondaryContrast;
                    },
                    color: HexColor.fromHex(HexCodes.secondaryContrast),
                    shape: CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              Container(
                width: 55,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: FlatButton(
                    onPressed: () {
                      this.noteCopy.color = HexCodes.standardNote;
                    },
                    color: HexColor.fromHex(HexCodes.standardNote),
                    shape: CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              Container(
                height: 37,
                width: 58,
                padding: EdgeInsets.fromLTRB(4, 0, 5, 0),
                child: FlatButton(
                  color: HexColor.fromHex(noteCopy.color),
                  shape: CircleBorder(side: BorderSide(color: Colors.white)),
                  onPressed: () {
                    setDisplayState(StateKey.COLOR_PICKER);
                  },
                  child: Icon(Icons.edit, color: Colorrs.buttonIcon, size: 19),
                )
              )
    ])));
  }
}

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class FolderSettings extends StatefulWidget {
  final Function setDisplayState;
  Note folder;

  FolderSettings(this.folder, this.setDisplayState);

  @override
  _FolderSettingsState createState() => _FolderSettingsState(this.folder, setDisplayState);
}

class _FolderSettingsState extends State<FolderSettings> {
  final Function setDisplayState; 
  Note folder;
  Function delete;
  Function update;

  _FolderSettingsState(this.folder, this.setDisplayState);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Sizes.noteOpenHeight,
      child: Stack(
        children: [
          ColorSettings(
            this.folder,
            new Note(
                title: this.folder.title,
                text: this.folder.text,
                id: this.folder.id,
                created: this.folder.created,
                location_id: this.folder.location_id,
                locationDefinition: this.folder.locationDefinition,
                is_folder: this.folder.is_folder,
                list_index: this.folder.list_index,
                color: HexCodes.main // bitte aendern !!!!!!!!!!!!!!!!!!!!!       
            ),
            this.setDisplayState
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final UserRepository userRepository = UserRepository(); 

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void setSaveNotesInTheCloud(value){
    setState(() {
      setBool(key: globals.Keys.SAVE_ON_CLOUD, value: !globals.settings[globals.Keys.SAVE_ON_CLOUD]); 
    });
  }

  void setSaveNotesOnPhone(value){
    setState(() {
      if (globals.settings[globals.Keys.SAVE_ON_PHONE])
      {
        Navigator.push(
          context,
          MaterialPageRoute( 
            builder: (context) => AreYouSureAboutThat()));
        }
      setBool(key: globals.Keys.SAVE_ON_PHONE, value: !globals.settings[globals.Keys.SAVE_ON_PHONE]); 
    });
  }

  void showNotifications(){

  }

  void onLogoutButtonPressed(){
    widget.userRepository.deleteToken();
    globals.authenticationBloc.add(LoggedOut());
    globals.loginBloc.add(LoginFailed(error: null));
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text(  
            'settings',
            style: Styles.folderTitleText,
          ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false, // hide the back button
      ),
      backgroundColor: Colorrs.background,
      body: Stack(
        children: [
      Scaffold( 
        backgroundColor: Colorrs.background,
          body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Center(  
                child: OnOffSetting( 
                  description: 'save notes on phone',
                  onChanged: setSaveNotesOnPhone,
                  value: globals.settings[globals.Keys.SAVE_ON_PHONE],
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: OnOffSetting(
                  description: 'save notes in the cloud',
                  onChanged: setSaveNotesInTheCloud,
                  value: globals.settings[globals.Keys.SAVE_ON_CLOUD],
                ),
              ),
              SizedBox(height: 15),
              ButtonSetting(  
                description: 'your notifications',
                onPressed: showNotifications,
                color: HexColor.fromHex(HexCodes.secondaryContrast),
              ),
              SizedBox(height: 15),
              ButtonSetting(  
                description: 'logout',
                onPressed: onLogoutButtonPressed,
                color: HexColor.fromHex(HexCodes.main),
              )

            ]
          )
            
          )
        ),
        Positioned( 
          bottom: 8.7,
          left: 20,
          child: MaterialButton(
            height: 40,
            minWidth: 40,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colorrs.addNote,
            shape: CircleBorder(  
              side: BorderSide(color: Colors.white)
            ), 
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi), 
              child: Icon(Icons.last_page, color: Colors.white, size: 20, )),
            )
          ),
        ]
      ),
    );
  }
}
// setState(() {
//                                   setBool(key: globals.Keys.SAVE_ON_CLOUD, value: !globals.settings[globals.Keys.SAVE_ON_CLOUD]); 
//                                 });

class AreYouSureAboutThat extends StatefulWidget {
  @override
  _AreYouSureAboutThatState createState() => _AreYouSureAboutThatState();
}

class _AreYouSureAboutThatState extends State<AreYouSureAboutThat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorrs.background,
      body: Stack(  
        children: [
          Center( 
            child: Text( 
              'are you sure about that \n every note on your device gets deleted'
            )
          ),
          Positioned(   
            bottom: 20,
            left: 25,
            child: MaterialButton(  
              onPressed:((){
                Navigator.pop(context);
              }),
              child: Text(  
                'back', 
                style: Styles.backButtonText,
              ),
            ),
          ),
          Positioned(   
            bottom: 20,
            right: 25,
            child: MaterialButton(  
              onPressed:((){
                
              }),
              child: Text(  
                'yes', 
                style: Styles.backButtonText,
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}

