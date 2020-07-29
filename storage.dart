import 'dart:developer';
import 'package:RESTAPI/blocs/authentication/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'dbHelper.dart';
import 'services/service.dart';
import 'models/note.dart';
import 'globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class to manage everything with storage 
// combines local storage and server storage 

FlutterSecureStorage secureStorage = FlutterSecureStorage();
Service server = Service();
DBHelper dbHelper = DBHelper();
UserRepository userRepository = UserRepository();

enum Action{
  DELETE, UPDATE, SAVE, GET
}

// function for handling note storage events 
void handleNoteStorage(Note note, Action action){
  if (globals.settings[Keys.SAVE_ON_CLOUD]){
    if(action == Action.DELETE){
      server.deleteNote(note);
    }
    else if (action == Action.SAVE){
      server.saveNote(note);
      increaseNoteCount();
    }
    else if (action == Action.UPDATE){
      appendUpdatedNote(note);
    }
  }
  if (globals.settings[Keys.SAVE_ON_PHONE]){
    if (action == Action.DELETE){
      dbHelper.delete(note.id);
    }
    else if (action == Action.SAVE){
      dbHelper.save(note);
      increaseNoteCount();
    }
    else if (action == Action.UPDATE){
      dbHelper.update(note);
    }
  }
}

void setBool({Keys key, bool value}) async {
  final _prefs = await SharedPreferences.getInstance();
  settings[key] = value;
  _prefs.setBool(key.toString(), value);
}

void loadSettings() async {
  print('loading settings..');
  final _prefs = await SharedPreferences.getInstance(); 
  settings.forEach((key, value) {
    switch (value.runtimeType){
      case bool:
        value = _prefs.getBool(key.toString()); 
        print('fetching setting: ' + key.toString() + ' with value: ' + value == null ? true : value);
        return settings[key] = value == null ? true : value;
      case String: 
        value = _prefs.getString(key.toString());
        print('fetching setting: ' + key.toString() + ' with value: ' + value == null ? true : value);
        return settings[key] = value == null ? 'Klodwig' : value;
    }
  });
}

void increaseNoteCount() async {
  getNoteCount().then((value) async {
    if(settings[Keys.SAVE_ON_PHONE]){
      print('increasing note count on local storage..');
      final _prefs = await SharedPreferences.getInstance();
      _prefs.setInt(Keys.NOTE_COUNT.toString(), value + 1);
    }
    if(settings[Keys.SAVE_ON_CLOUD]){
      print('increasing note count on server side..');
      server.setNoteCount(value + 1);
    }
    print('new note count: ' + (value + 1).toString());
  });
}

Future<int> getNoteCount() async { 
  final _prefs = await SharedPreferences.getInstance();
  Future<int> noteCount;
  if (settings[Keys.SAVE_ON_PHONE]){
    print('fetching note count from local storage..');
    noteCount = Future<int>.value(_prefs.getInt(Keys.NOTE_COUNT.toString()));
  }
  if (settings[Keys.SAVE_ON_CLOUD]) {
    print('fetching note count from server..');
    noteCount = server.getNoteCount();
  }
  print('note count: ' + noteCount.toString());  
  return noteCount;
}

Future<void> setNoteCount(count) async {
  if(settings[Keys.SAVE_ON_PHONE]){
    print('setting note count on local storage: ' + count.toString());
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setInt(Keys.NOTE_COUNT.toString(), count);
  }
  if(settings[Keys.SAVE_ON_CLOUD]){
    print('setting note count on server: ' + count.toString());
    server.setNoteCount(count);
  }
}

Future<List> getNotes({int location}){
  if (settings[Keys.SAVE_ON_CLOUD]){
    print(getNotes.toString() + ' fetching notes from server..');
    return server.getNotes(location: location);
  }
  if (settings[Keys.SAVE_ON_PHONE]){ 
    print('fetching notes from local storage..');
    return location != null ? // because dbHelper doesnt support dynamic location
    dbHelper.getContent(location) : dbHelper.getNotes();
  }
  return null;
}

Future<void> deleteData() async {
  final _prefs = await SharedPreferences.getInstance();
  _prefs.clear();
  await userRepository.deleteToken();
  dbHelper.deleteAll();
}

// function called when note gets updated 
// updated note gets appended to note update list to keep track of what notes need to be updated in server 
List updatedNotes = []; 
void appendUpdatedNote(Note note){
  updatedNotes.removeWhere((element) => element.id == note.id); 
  updatedNotes.add(note);
}

const updateDuration = const Duration(seconds: 2);

void updateServerStorage(){ 
  
  print(updatedNotes.length);
  if (updatedNotes.length > 0){
    // if(globals.settings[Keys.SAVE_ON_PHONE]) { 
    //   dbHelper.getNotes().then((value){ 
    //     value.forEach((i) { 
    //       updatedNotes.forEach((j) {
    //         if (j.id == i.id) {
    //           server.updateNote(i);
    //           updatedNotes.remove(j);
    //         }
    //       });
    //     });
    //   });
    // }
    if(globals.settings[Keys.SAVE_ON_CLOUD]) { 
      print('updating server storage...');
      for(int i = 0; i < updatedNotes.length; i++){
        server.updateNote(updatedNotes[i]);
        updatedNotes.removeAt(i);
      }
    }
  }
}

Future<Note> getNoteById(int id){
  if(settings[Keys.SAVE_ON_CLOUD]){
    return server.getNoteById(id);
  }
  if(settings[Keys.SAVE_ON_PHONE]){
    // return dbHelper.getNoteById();
  }
}
// Future<void> compareNotes() async {
//   List localNotes = await dbHelper.getNotes();
//   List cloudNotes = await server.getNotes();

//   for(int i = 0; i < localNotes.length; i++){
//     bool exists = false;
//     for(int j = 0; j < cloudNotes.length; i++){
//       if(localNotes[i].id == cloudNotes[j].id) exists = true; 
//     }
//     if(!exists) server.saveNote(localNotes[i]);
//   }
// }
