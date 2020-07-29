import 'dart:async';
import 'package:RESTAPI/dbHelper.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/note.dart';
import '../styles.dart';
import '../models/root.dart';
import 'package:RESTAPI/storage.dart' as storage;

class Search extends StatefulWidget {
  final Function updateLast;
  Search({this.updateLast});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // system 
  List notes = [];
  DBHelper dbHelper = DBHelper();
  Service server = Service();
  TextEditingController searchController = TextEditingController();
  Mode mode = Mode.VIEW;
  // build variables 
  final scrollController = ScrollController();
  Timer timer;

  @override 
  void initState(){
    super.initState(); 
    storage.getNotes().then((value){
      setState(() {
        notes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
      onWillPop: onBackButton,
      child: Scaffold(
        appBar: AppBar(  
        title:  TextBox(update, searchController),
        automaticallyImplyLeading: false, // hide the back button
        backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colorrs.background,
        body: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(  
            controller: scrollController,
            child: Container(  
              height: getSize(notes),
              child: Theme(  
                data: ThemeData(  
                  canvasColor: Colors.transparent
                ),
                child: Column(  
                  children: getNoteContainer(filter(notes))
                )
              )
            )
          )
        )
      )
    );
  }
  
  // delete not from database and listview
  void deleteNote(Note note){
    setState(() {
      storage.handleNoteStorage(note, storage.Action.DELETE);
      this.notes.remove(note);
      updateSize();
    });
  }
  // filters notes givent text in search controller
  List filter(List unfiltered){
    List filtered = [];
    for(int i = 0; i < notes.length; i++){
      if(unfiltered[i].title.contains(searchController.text) && unfiltered[i].is_folder != 1){
        filtered.add(notes[i]);
      }
    }
    return filtered;
  }
  // returns list of container the notes are in
  List<Container> getNoteContainer(List notes) {
    return notes.map((note){
      return Container(
        key: UniqueKey(),
        decoration: BoxDecoration(   
          color: Colors.transparent
        ),
        padding: EdgeInsets.all(Sizes.noteSpace/2),
        child: NoteBox(note, this.updateSize, this.deleteNote, widget.updateLast, mode, (){}),
      );
    }).toList();
  }
  // gets size of container the notes are in
  double getSize(List notes){
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
  // function to jump to last folder 
  void goToLastFolder(){
    widget.updateLast();
    Navigator.pop(context, true);
  }
  // function to update the hole folder (currently only placeholder)
  void update(){
    setState(() {
    });
  }
  //updates the size of container the notes are in
  void updateSize(){
    setState(() {
      
    });
  }

  Future<bool> onBackButton(){
    goToLastFolder();
    return Future.value(true);
  }
  // resets all updateable values if user uses backbutton without closing notes 
  // (not used)
  void closeNotes(){
    for(int i = 0; i < notes.length; i++){
      notes[i].updateable = !notes[i].updateable;
    }
  }
}
// inside appbar for controlling folder title
class TextBox extends StatelessWidget{
  TextEditingController searchController;
  Function updateNotes;

  TextBox(this.updateNotes, this.searchController){
    searchController.addListener(updateNotes);
  }
  // build the helicopter
  @override
  Widget build(BuildContext context){
    return Container( 
      alignment: Alignment.center,
      color: Colors.black,
      child: TextFormField(  
        textAlign: TextAlign.center,
        autofocus: true,
        maxLength: 25,
        controller: searchController,
        decoration: Decorations.searchInput,
        style: Styles.folderTitleText,       
      ),
    );
  }
}






























































  // @override
  // Widget build(BuildContext context) {
  //     server.getNotes();
  //     return Scaffold(
  //       appBar: AppBar(  
  //         title:  TextBox(update, searchController),
  //         automaticallyImplyLeading: false, // hide the back button
  //         backgroundColor: Colors.transparent,
  //       ),
  //       backgroundColor: Colorrs.background,
  //       body: FutureBuilder<List>(
  //         future: notes,
  //         builder: (BuildContext context, AsyncSnapshot<List> snapshot){
  //           if (snapshot.hasData){
  //             this.notes = snapshot.data;
  //             List<Container> items = getNoteContainer(filterNotes(snapshot.data));
  //             return Scaffold(
  //              backgroundColor: Colors.transparent,
  //               body: SingleChildScrollView(  
  //                 controller: scrollController,
  //                 child: Container(  
  //                   height: getSize(snapshot.data),
  //                   child: Theme(  
  //                     data: ThemeData(  
  //                       canvasColor: Colors.transparent
  //                     ),
  //                     child: Column(  
  //                       children: items
  //                     )
  //                   )
  //                 )
  //               )
  //             );
  //           }
  //           else{
  //             return Container(  
  //               color: Colors.green,
  //             );
  //           }
  //         }
  //       )
  //     );
  //   // });
  // }