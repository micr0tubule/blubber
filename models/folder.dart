import 'dart:async';
import 'package:RESTAPI/dbHelper.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/storage.dart';
import 'package:RESTAPI/views/actionsBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'note.dart';
import '../styles.dart';
import '../views/search.dart';
import 'root.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'package:RESTAPI/storage.dart' as storage;
import '../views/standardWidgets/TitleTextBox.dart';

class Folder extends StatefulWidget {
  final Note folder;
  final Function updateLast;

  Folder(this.folder, this.updateLast);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  // system 
  int location;
  List notes = [];
  DBHelper dbHelper = DBHelper();
  Service server = Service();
  // build variables 
  final scrollController = ScrollController();
  double _height;
  Mode mode;
  
// variables for moving notes in different locations
  Note selectedFolder;
  List selectedNotes = [];



  @override 
  void initState(){
    super.initState();
    this.location = widget.folder.locationDefinition;
    this._height = getSize();
    storage.getNotes(location: this.location).then((value) {
      setState(() {
        if(value != null) this.notes = value;
      });
    });
    setMode();
  }

  void updateFolderTitle({Note objectWithTitle, String title}) {
    widget.folder.title = title;
    storage.handleNoteStorage(objectWithTitle, storage.Action.UPDATE); 
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFolder != null) { 
      changeNoteLocation(selectedNotes, selectedFolder);
    }
    List<Container> items = getNotes();
    return WillPopScope(
      onWillPop: onBackButton,
      child: Scaffold(
        appBar: AppBar(  
          title:  TitleTextBox(
            objectWithTitle: widget.folder,
            listener: updateFolderTitle,
          ),
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colorrs.background,
        body: RefreshIndicator(
          backgroundColor: Colorrs.background,  
          color: Colors.white,
          onRefresh: () async {
            storage.getNotes(location: this.location).then((value) {
              setState(() {
                notes = value;  
                items = getNotes();
              });
            });
          },
          child: Stack(
          children: [
            this.notes.length == 0 ? 
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children : <Widget>[
                Container(  
                    height: 120,
                    child: Image(image: AssetImage('assets/beanos_icon.png')),
                ),
                Text(  
                  'no notes yet',
                  style: TextStyle(  
                    color: Colors.white,
                    fontFamily: Fonts.standard,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
                  
                ]
              ) 
            ) 
          : 
            Container(),
            Scaffold(  
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(  
                controller: scrollController,
                child: Container(  
                  height: getSize(),
                  child: Theme(  
                    data: ThemeData(  
                      canvasColor: Colors.transparent
                    ),
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex){
                        reorder(oldIndex, newIndex);
                      },  
                      children: getNotes()
                    )
                  )
                )
              )
            ),
            ActionsBar(
              this.addNote, 
              this.addFolder, 
              navigateSearch: this.navigateSearch, 
              changeLocation: (){},
              onBackButton: this.onBackButton, 
              note: widget.folder, 
              selectedNotes: selectedNotes,
              closeNotes: this.closeNotes,
              selectFolder: selectFolder,
              selectedFolder: selectedFolder,
              motherMode: mode,
              setMode: setMode
              )
          ]
        )
      )
      )
    );
  }
  // adds note to database and refreshes state of listview
  void addNote(){
    setState((){
      Note note = Note(
          title: '', 
          text: '', 
          id: globals.noteCount + 1,
          created: '${DateTime.now().day.toString()} ${DateTime.now().month.toString()} ${DateTime.now().year.toString()}', 
          location_id: this.location,
          locationDefinition: -10, 
          is_folder: 0, 
          list_index: notes.length, 
          color:HexCodes.standardNote 
      );
      note.open = true;
      note.setDisplayState(StateKey.DISPLAY);
      note.updateable = true;
      handleNoteStorage(note, storage.Action.SAVE);
      globals.noteCount += 1;
      this.notes.add(note);
      updateSize();
      Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent - notes.length * Sizes.addNoteOffset));
    });
  
  }
  // adds folder to database and refreshes state of listview
  void addFolder(){
    setState((){
      dbHelper.getNewLocationId().then((locationDefinition){
        Note folder = new Note(
          title: '', 
          text: '', 
          id: globals.noteCount + 1,
          created: '${DateTime.now().day.toString()} ${DateTime.now().month.toString()} ${DateTime.now().year.toString()}', 
          location_id: this.location,
          locationDefinition: locationDefinition + 1, 
          is_folder: globals.noteCount + 1, 
          list_index: notes.length, 
          color:HexCodes.standardNote
        );
        handleNoteStorage(folder, storage.Action.SAVE);
        globals.noteCount += 1;
        this.notes.add(folder);
        updateSize();
        Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent - notes.length * Sizes.addNoteOffset));
      });    
    
    });
  }
  // delete not from database and listview
  void deleteNote(Note note){
    setState(() {
      handleNoteStorage(note, storage.Action.DELETE);
      this.notes.remove(note);
      updateSize();
    });
  }
  // returns list of container the notes are in
  List<Container> getNotes(){
    sort();
    return notes.map((note){
      return Container(
        key: Key(note.id.toString()),
        decoration: BoxDecoration(   
          color: Colors.transparent
        ),
        padding: EdgeInsets.all(Sizes.noteSpace/2),
        child: NoteBox(note, this.updateSize, this.deleteNote, this.update, mode, selectNote, selectFolder: selectFolder),
      );
    }).toList();
  }
  // gets size of container the notes are in
  double getSize(){
    double size = 0;
    for(int i = 0; i < notes.length; i++){
      if(notes[i].open){
        size += (Sizes.noteOpenHeight + Sizes.noteSpace + Sizes.addNoteOffset);
      }
      else {
        size += (Sizes.noteClosedHeight + Sizes.noteSpace + Sizes.addNoteOffset);
      }
    }
    return size;
  }

  void navigateSearch(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => Search(updateLast: widget.updateLast))
    );
  }
  // function to update the hole folder (currently only placeholder)
  void update(){
    setState(() { 
      this._height = getSize();
    });
  }
  //updates the size of container the notes are in
  void updateSize(){
    setState(() {
      this._height = getSize();
    });
  }
  // resets all updateable values if user uses backbutton without closing notes 
  // (not used)
  void closeNotes(){
    for(int i = 0; i < notes.length; i++){
      notes[i].updateable = !notes[i].updateable;
    }
  }


  Future<bool> onBackButton(){
    widget.updateLast();
    storage.handleNoteStorage(widget.folder, storage.Action.UPDATE);
    return Future.value(true);
  }

  void reorder(int old, int new_){
    notes[old].list_index = new_;
    storage.handleNoteStorage(notes[old], storage.Action.UPDATE);
    setState(() {
      if(old < new_){
        for(int i = 0; i < notes.length; i++){
          if(i > old && i <= new_){
            print('hallo');
            notes[i].list_index -= 1;
            storage.handleNoteStorage(notes[i], storage.Action.UPDATE);
          }
        }
      } 
      else{
        for (int i = 0; i < notes.length; i++){
          if (i < old && i >= new_){
            notes[i].list_index += 1;
            storage.handleNoteStorage(notes[i], storage.Action.UPDATE);
          }
        }
      }
    });
  }

  void sort(){
    notes.sort((a, b) => a.list_index.compareTo(b.list_index));
  }

  

  void selectNote(Note note){
    setState(() {
      print('selectNote');
      note.states[StateKey.SELECTED] ? 
        selectedNotes.removeWhere((element) => element.id == note.id) : 
        selectedNotes.add(note);
      note.states[StateKey.SELECTED] = !note.states[StateKey.SELECTED];
      setMode();      
    });
  }

  selectFolder(Note folder){
    setState(() {
      selectedFolder = folder;
    });
  }

  void setMode({Mode mode}){
    setState(() {
      if (mode == null){
        this.mode = selectedNotes.length == 0 ?
        Mode.VIEW : Mode.SELECT; 
      }
      else {
        this.mode = mode;
      }
      if (this.mode == Mode.VIEW) {
        this.selectedNotes = [];
        this.selectedFolder = null;
        print('hallo');
      }
    });
  }
  
  void setModeInsideBuild({Mode mode}){
    if (mode == null){
        this.mode = selectedNotes.length == 0 ?
        Mode.VIEW : Mode.SELECT; 
      }
    else {
      this.mode = mode;
    }
    if (this.mode == Mode.VIEW) {
      this.selectedNotes = [];
      this.selectedFolder = null;
    }
  }

  void changeNoteLocation(List notes, Note folder){
    for(int i = 0; i < notes.length; i++){
      if(notes[i].id != folder.id){
        this.notes.removeWhere((element) => element.id == notes[i].id);
        notes[i].location_id = folder.locationDefinition;
        storage.handleNoteStorage(notes[i], storage.Action.UPDATE);
      }
    }
    setModeInsideBuild(mode: Mode.VIEW); 
  }





}
