import 'package:RESTAPI/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:RESTAPI/styles.dart';
import '../../models/note.dart';

class TitleTextBox extends StatelessWidget {

  TitleTextBox({
    this.objectWithTitle, 
    // exspected listener parameters: Note objectWithTitle, String title
    this.listener,
    this.controller 
  }){
    controller = controller == null ? TextEditingController() : controller;
    controller.text = objectWithTitle.title;
    controller.addListener((){
      listener(
        objectWithTitle: objectWithTitle, 
        title: controller.text
      );
    });
  }

  final Note objectWithTitle;
  final Function listener;
  TextEditingController controller;
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context){
    return Container( 
      alignment: Alignment.center,
      color: Colors.black,
      child: TextFormField(  
        textAlign: TextAlign.center,
        maxLength: 25,
        controller: this.controller,
        decoration: Decorations.changeTitleOfFolder,
        style: Styles.folderTitleText,       
      ),
    );
  }
}