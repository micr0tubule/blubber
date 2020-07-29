import 'package:RESTAPI/dbHelper.dart';
import 'package:RESTAPI/globals.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/storage.dart' as storageManager; // sometimes its also called "storage"
import 'package:RESTAPI/views/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../styles.dart';
import 'package:json_annotation/json_annotation.dart';
import '../dbHelper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/note.dart';
import 'notification.dart';
import 'package:RESTAPI/DatePicker/flutter_holo_date_picker.dart';


class NoteFullScreen extends StatefulWidget {
  final Note note;
  final Function deleteNote;
  final TextEditingController titleController;
  final TextEditingController textController;

  NoteFullScreen({this.note, this.titleController, this.textController, this.deleteNote});

  @override
  _NoteFullScreenState createState() => _NoteFullScreenState();
}

class _NoteFullScreenState extends State<NoteFullScreen> {

  // DateTime initialDateTime  ;
  // DateTime firstDateTime;
  // DateTime secondDateTime;
  // DateTime thirdDateTime;

  void updateNote(){ 
    storageManager.handleNoteStorage(widget.note, storageManager.Action.UPDATE);
  }

  void _delete(){
    widget.deleteNote(widget.note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(  
          title: TextBox(widget.note, titleController: widget.titleController),
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colorrs.background,
        body: Stack(  
          children: [
            Center( 
              child: Container(                
              // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              // width: MediaQuery.of(context).size.width - 17,
              child: TextField(
                cursorColor: HexColor.fromHex(HexCodes.main),
                controller: widget.textController,
                textAlign: TextAlign.left,
                maxLines: 2000,
                style: Styles.text,
                decoration: InputDecoration(  
                  focusedBorder: OutlineInputBorder(  
                    borderSide: BorderSide(  
                      color: Colors.transparent
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(  
                    borderSide: BorderSide(color: Colors.transparent)
                    ),
                  )
                )
              )
            ),
            Positioned(  
              bottom: 8.7,
              right: 20,
                child: MaterialButton(  
                  height: 40,
                  minWidth: 40,
                  onPressed: (){  
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmDeleteScreen(delete: _delete)));
                  },
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white)
                ),
                child: Icon(Icons.delete, color: Colorrs.buttonIcon, size: 20),
                color: Colorrs.deleteNote,
              )
            ),
            Positioned(  
              bottom: 8.7,
              right: 75,
              child: MaterialButton(  
                height: 40,
                minWidth: 40,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SetNotificationScreen(note: widget.note)));
                },
                color: Colorrs.addNote,
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white)
                ),
                child: Icon(Icons.notifications, color:Colorrs.addNoteIcon, size: 20),
              ) 
            ),
          ],
        ),
      ) 
    );
  }
}

// inside appbar for controlling folder title
class TextBox extends StatelessWidget{
  Note note;
  DBHelper dbHelper;
  TextEditingController titleController;

  TextBox(this.note, {this.titleController}){
    dbHelper = DBHelper();
    titleController.text = note.title;
    titleController.addListener(updateNote);
  }
  void updateNote(){
    note.title = titleController.text;
    storageManager.handleNoteStorage(note, storageManager.Action.UPDATE);
  }
  // build the helicopter
  @override
  Widget build(BuildContext context){
    return Container( 
      alignment: Alignment.center,
      color: Colors.black,
      child: Container( 
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: TextFormField(  
          cursorColor: HexColor.fromHex(HexCodes.main),
          textAlign: TextAlign.center,
          maxLength: 25,
          controller: titleController,
          decoration: Decorations.changeTitleOfFolder,
          style: Styles.folderTitleText,       
        ),
      )
    );
  }
}

class ConfirmDeleteScreen extends StatefulWidget {
  @override
  _ConfirmDeleteScreenState createState() => _ConfirmDeleteScreenState();

  ConfirmDeleteScreen({this.delete});

  Function delete;
}

class _ConfirmDeleteScreenState extends State<ConfirmDeleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(  
        children: <Widget>[
          Center(  
            child: Text(  
              'Are you sure about that?',
              style: Styles.titlePreview,
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
                  Navigator.pop(context);
                },  
                child: Text(  
                  'no',
                  style: Styles.loginSwitchButton,
                ),
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
                  widget.delete();
                  Navigator.pop(context);
                },  
                child: Text(  
                  'yes',
                  style: Styles.loginSwitchButton,
                ),
              )
            )
          ),

        ],
      )
    );
  }
}

