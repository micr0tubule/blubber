import 'dart:async';
import 'package:RESTAPI/dbHelper.dart';
import 'package:RESTAPI/storage.dart';
import 'package:RESTAPI/views/actionsBar.dart';
import 'package:flutter/material.dart';
import 'note.dart';
import '../styles.dart';
import '../views/search.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'package:RESTAPI/storage.dart' as storageManager;


class Root extends StatefulWidget {

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  // system 
  int location = -1;
  List notes = [];
  List<Container> items = [];
  DBHelper dbHelper = DBHelper();
  Service server = Service();
  Mode mode;
  // build variables 
  final scrollController = ScrollController();
  double _height;
// variables for moving notes in different locations
  bool selectingFolder = false;
  Note selectedFolder;
  List selectedNotes = [];

  @override
  void initState(){
    super.initState();
    globals.load();
    this._height = getSize();
    if(globals.token == null || globals.token == 'Gertrude'){
      storageManager.secureStorage.read(key: 'token').then((value){
        globals.token = value;
        storageManager.getNotes(location: location).then((value){ 
          setState(() {
            if (value != null) this.notes = value;
            items = getNotes();
          });
        });
      });
    }
    else{
      storageManager.getNotes(location: location).then((value){
        setState(() {
          if (value != null) this.notes = value;
          items = getNotes();
        });
      });
    }
    setMode();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFolder != null) { 
      changeNoteLocation(selectedNotes, selectedFolder);
    }
    return Scaffold(
      appBar: AppBar(  
        title: Text(  
            'root',
            style: Styles.folderTitleText,
          ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false, // hide the back button
      ),
      backgroundColor: Colorrs.background,
      body: RefreshIndicator( 
        
        backgroundColor: Colorrs.background,  
        color: Colors.white,
        onRefresh: () async {
          storageManager.getNotes(location: this.location).then((value) {
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
            backgroundColor: Colorrs.background,
            body: SingleChildScrollView(  
              controller: scrollController,
                child: Container(  
                height: getSize(),
                child: Theme(  
                  data: ThemeData(  
                    canvasColor: Colors.transparent
                  ),
                  child: ReorderableListView(  
                    onReorder: (oldIndex, newIndex){
                      reorder(oldIndex, newIndex);
                    },
                    children: getNotes()
                  )
                )
              )
            ),
          ),
         
          ActionsBar(
            this.addNote, 
            this.addFolder, 
            changeLocation: changeNoteLocation,
            navigateSearch: navigateSearch, 
            onBackButton: update, 
            selectedNotes: selectedNotes,
            motherMode: mode,
            selectedFolder: selectedFolder,
            selectFolder: selectFolder,
            setMode: setMode,
            makeFolderView: makeFolderView
          )
        ]
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
        note.updateable = true;
        note.setDisplayState(StateKey.DISPLAY);
        this.notes.add(note);
        handleNoteStorage(note, storageManager.Action.SAVE);
        globals.noteCount += 1;
        updateSize();
        Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent - notes.length * Sizes.addNoteOffset));
    });
  }
  // adds folder to database and refreshes state of listview
  void addFolder(){
    setState((){
      dbHelper.getNewLocationId().then((locationDefinition){
        Note folder = Note(
          title: '', 
          text: '', 
          id: globals.noteCount + 1,
          created: '${DateTime.now().day.toString()} ${DateTime.now().month.toString()} ${DateTime.now().year.toString()}', 
          location_id: this.location,
          locationDefinition: globals.noteCount + 1, 
          is_folder: 1, 
          list_index: notes.length, 
          color:HexCodes.standardNote
        );
        handleNoteStorage(folder, storageManager.Action.SAVE);
        globals.noteCount += 1;
        notes.add(folder);
        updateSize();
        Timer(Duration(milliseconds: 100), () => scrollController.jumpTo(scrollController.position.maxScrollExtent - notes.length * Sizes.addNoteOffset));
      });    
    });
  }
  // delete not from database and listview
  void deleteNote(Note note){
    setState(() {
      handleNoteStorage(note, storageManager.Action.DELETE);
      notes.remove(note);
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
        child: NoteBox(note, updateSize, deleteNote, update, mode, selectNote, selectingFolder: selectingFolder, selectFolder: selectFolder),
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

  void update(){
    storageManager.getNotes(location: location).then((value){
      setState(() {
        this.notes = value;
        this._height = getSize();
      });
    });
  }
  // navigate to search page
  void navigateSearch(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => Search(updateLast: update))
    );
  }
  //updates the size of container the notes are in
  void updateSize(){
    setState(() {
      this._height = getSize();
    });
  }

  void reorder(int old, int new_){
    notes[old].list_index = new_;
    storageManager.handleNoteStorage(notes[old], storageManager.Action.UPDATE);
    setState(() {
      if(old < new_){
        for(int i = 0; i < notes.length; i++){
          if(i > old && i <= new_){
            notes[i].list_index -= 1;
            storageManager.handleNoteStorage(notes[i], storageManager.Action.UPDATE);
          }
        }
      } 
      else{
        for (int i = 0; i < notes.length; i++){
          if (i < old && i >= new_){
            notes[i].list_index += 1;
            storageManager.handleNoteStorage(notes[i], storageManager.Action.UPDATE);
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
        storageManager.handleNoteStorage(notes[i], storageManager.Action.UPDATE);
      }
    }
    setModeInsideBuild(mode: Mode.VIEW); 
  }

  void makeFolderView(){
    setState(() {
      this.notes.removeWhere((element) => element.is_folder == 0);
    });
  }
}

enum Mode{ 
  SELECT, VIEW, SELECT_FOLDER
}

