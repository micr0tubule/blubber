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
  // build variables 
  final scrollController = ScrollController();
  double _height;

  @override
  void initState(){
    super.initState();
    globals.load();
    this._height = getSize();
    if(globals.token == null){
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
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
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
            )
          ),
          // ActionsBar(this.addNote, this.addFolder, navigateSearch: navigateSearch, onBackButton: update)
        ]
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
          locationDefinition: locationDefinition + 1, 
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
          // child: NoteBox(note, this.updateSize, this.deleteNote, this.update)
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
      for (int i = 0; i < notes.length; i++){
        print(notes[i].list_index);
      }
    });
  }

  void sort(){

    notes.sort((a, b) => a.list_index.compareTo(b.list_index));
    
  }
}
