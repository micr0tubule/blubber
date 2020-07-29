import 'package:flutter/material.dart';
import 'package:RESTAPI/styles.dart';
import 'package:RESTAPI/models/note.dart';
import 'dart:math' as math;
import 'settings.dart';
import '../models/root.dart';

class ActionsBar extends StatefulWidget {
  final Function addNote;
  final Function addFolder;
  final Function onBackButton;
  final Function navigateSearch;
  final Function closeNotes;
  final Note note;
  final Mode motherMode; 
  final Function changeLocation; 
  final List selectedNotes;
  final Function selectFolder;
  final Note selectedFolder;
  final Function setMode;
  final Function makeFolderView;

  ActionsBar(
    this.addNote, 
    this.addFolder, 
    {
    this.changeLocation, 
    this.navigateSearch, 
    this.selectFolder,
    this.onBackButton, 
    this.note, 
    this.selectedFolder,
    this.selectedNotes, 
    this.closeNotes, 
    this.setMode,
    this.motherMode: Mode.VIEW,
    this.makeFolderView});

  @override
  _ActionsBarState createState() => _ActionsBarState();
}

class _ActionsBarState extends State<ActionsBar> {
  Function closeNotes;

  Icon addButtonIcon = Icon(Icons.add, color:Colorrs.addNoteIcon, size: 15); 
  Color addButtonColor = Colorrs.addNote;
  Color cancelAddNoteColor = Colorrs.deleteNote;
  bool addButtonActive = false;
  Note onChangeLocationFolder;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.motherMode == Mode.VIEW ? 
     Stack(
      children: [
        // add folder or note button 
        Positioned(  
          bottom: 8.7,
          right: 20,
            child: MaterialButton(  
              height: 40,
              minWidth: 40,
              onPressed: (){
                setState(() {     
                  if(!addButtonActive){
                    addButtonActive = true;
                    addButtonColor = cancelAddNoteColor;
                    addButtonIcon = Icon(Icons.close, color: Colorrs.addNoteIcon, size: 20);
                  }          
                  else{
                    addButtonActive = false;
                    addButtonColor = Colorrs.addNote;
                    addButtonIcon = Icon(Icons.add, color:Colorrs.addNoteIcon, size: 20); 
                  }
                });
              },
            shape: CircleBorder(
              side: BorderSide(color: Colors.white)
            ),
            child: addButtonIcon,
            color: addButtonColor,
          )
        ),

        // add folder button
        Positioned(
          bottom: 120,
          right: 20,  
          child: Visibility(  
            visible: addButtonActive,
            child:  MaterialButton( 
              height: 40,
              minWidth: 40,
              onPressed: (){
                setState(() {
                  widget.addFolder();
                  if(!addButtonActive){
                    addButtonActive = true;
                    addButtonColor = cancelAddNoteColor;
                    addButtonIcon = Icon(Icons.cancel, color: Colorrs.addNoteIcon, size: 15);
                  }          
                  else{
                    addButtonActive = false;
                    addButtonColor = Colorrs.addNote;
                    addButtonIcon = Icon(Icons.add, color:Colorrs.addNoteIcon, size: 15); 
                  }
                });
              },
              color: HexColor.fromHex(HexCodes.main),
              shape: CircleBorder(
                side: BorderSide(color: Colors.white)
              ),
              child: Icon(Icons.folder, color:Colorrs.addNoteIcon, size: 20),
            )
          )
        ),
        // add note button
        Positioned(  
          bottom: 65, 
          right: 20,
          child: Visibility(  
            visible: addButtonActive,
            child: MaterialButton(  
              height: 40,
              minWidth: 40,
              onPressed: (){
                setState(() {
                  widget.addNote();
                  if(!addButtonActive){
                    addButtonActive = true;
                    addButtonColor = cancelAddNoteColor;
                    addButtonIcon = Icon(Icons.cancel, color: Colorrs.addNoteIcon, size: 15);
                  }          
                  else{
                    addButtonActive = false;
                    addButtonColor = Colorrs.addNote;
                    addButtonIcon = Icon(Icons.add, color:Colorrs.addNoteIcon, size: 15); 
                  }
                });
              },
              color: HexColor.fromHex(HexCodes.mainContrast),
              shape: CircleBorder(
                side: BorderSide(color: Colors.white)
              ),
              child: Icon(Icons.note, color:Colorrs.addNoteIcon, size: 20),
            ),
          ),
        ),
        // go back to last folder
        Positioned( 
          bottom: 8.7,
          left: 20,
          child: Visibility(  
          visible: widget.note != null, // only visible when this widget is folder
          child: MaterialButton(
            height: 40,
            minWidth: 40,
            onPressed: () {
              Navigator.pop(context, true);
              widget.onBackButton(); 
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
        ),
        // search note button 
        Visibility(  
          visible: true,
          child: Positioned(  
            bottom: 8.7,
            right: 75,
            child: MaterialButton(  
              height: 40,
              minWidth: 40,
              onPressed: (){
                setState(() {
                  widget.navigateSearch();
                });
              },
              color: Colorrs.addNote,
              shape: CircleBorder(
                side: BorderSide(color: Colors.white)
              ),
              child: Icon(Icons.search, color:Colorrs.addNoteIcon, size: 20),
            )
          )
        ),
        // settings button
        Positioned(  
          bottom: 8.7,
          right: 130,
          child: Visibility(  
            visible: true,
            child: MaterialButton(  
              height: 40,
              minWidth: 40,
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              color: Colorrs.addNote,
              shape: CircleBorder(
                side: BorderSide(color: Colors.white)
              ),
              child: Icon(Icons.settings, color:Colorrs.addNoteIcon, size: 20),
            )
          )
        ),

      ]
    ) : 
    Stack(  
      children: <Widget>[
        Positioned(  
          bottom: 8.7,
          right: 75,
          child: Visibility(  
            visible: true,
            child: MaterialButton(  
              height: 40,
              minWidth: 40,
              onPressed: (){
                // widget.makeFolderView();
                widget.setMode(mode: Mode.SELECT_FOLDER);
              },
              color: Colorrs.addNote,
              shape: CircleBorder(
                side: BorderSide(color: Colors.white)
              ),
              child: Icon(Icons.folder_open, color:Colorrs.addNoteIcon, size: 20),
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
              },
            shape: CircleBorder(
              side: BorderSide(color: Colors.white)
            ),
            child: Icon(Icons.delete, color: Colorrs.buttonIcon, size: 20),
            color: Colorrs.deleteNote,
          )
        ),
        
      ],
    );
  }
}


