import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'models/note.dart';

class DBHelper{
  static Database _db;
  static const String DB_NAME = 'note.db';
  // Table colums
  static const String TABLE = 'note';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String TEXT = 'text';
  static const String COLOR = 'color';
  static const String CREATED = 'created';
  static const String LOCATION_ID = 'location_id';
  static const String LOCATION_DEFINITION = 'locationDefinition';
  static const String IS_FOLDER = 'is_folder';
  static const String LIST_INDEX = 'list_index';
  
  // Initialize the database 
  Future<Database> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async{
    // get the devices documents directory to store the offline database..
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    // create the DB table
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TITLE TEXT, $TEXT TEXT, $COLOR TEXT, $CREATED TEXT, $LOCATION_ID INTEGER, $LOCATION_DEFINITION INTEGER, $LIST_INDEX, $IS_FOLDER INTEGER)");
  } 

  // insert note to database
  Future<Note> save(Note note) async {
    var dbClient = await db;
    note.id = await dbClient.insert(TABLE, note.toJson());
    return note; 
  }

  Future<void> saveNotes(List notes) async { 
    for(int i = 0; i < notes.length; i++){
      await this.save(notes[i]);
    }
  }
 
  // return all notes from the db
  Future<List<Note>> getNotes() async{
    var dbClient = await db;

    List<Map> maps = await dbClient.query(TABLE, columns: [TITLE, TEXT, ID, COLOR, LOCATION_ID, LOCATION_DEFINITION, IS_FOLDER, LIST_INDEX, CREATED]);
    List<Note> notes = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        notes.add(Note.fromJson(maps[i]));
      }
    }
    print('get notes dbHelper return: ' + notes.toString());
    return notes;
  }

  //   Future<List<Note>> getFilteredNotes(String keyWord) async{
  //   var dbClient = await db;

  //   List<Map> maps = await dbClient.query(TABLE, columns: [TITLE, TEXT, ID, COLOR, LOCATION_ID, LOCATION_DEFINITION, IS_FOLDER, CREATED]);
  //   List<Note> notes = [];
  //   if(maps.length > 0){
  //     for(int i = 0; i < maps.length; i++){
  //       Note note = Note.fromJson(maps[i]);
  //       if(note.title.contains(keyWord)){
  //         notes.add(note);
  //       } 
  //     }
  //   }
  //   return notes;
  // }

  

  // delete a note from the database
  Future<int> delete(int id) async{
    var dbClient = await db;
    return id == 9000 ? 
    await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]) : 
    await dbClient.delete(TABLE);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }
  // update a note in the database
  Future<int> update(Note note) async{
    var dbClient = await db;
    return await dbClient.update(TABLE, note.toJson(), where: '$ID = ?', whereArgs: [note.id]);
  }

  Future<int> getNewNoteId() async{ 
    var dbClient = await db;
    int value = Sqflite.firstIntValue( await dbClient.rawQuery("SELECT MAX($ID) FROM $TABLE"));
    if(value == null){
      return 0;
    }
    return value;
  }

  Future<int> getNewLocationId() async {
    var dbClient = await db;
    int value = Sqflite.firstIntValue(await dbClient.rawQuery("SELECT MAX($LOCATION_DEFINITION) FROM $TABLE"));
    return value == null ? 0 : value + 1;
  }

  Future<List<Note>> getContent(int locationId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [TITLE, TEXT, ID, COLOR, LOCATION_ID, LOCATION_DEFINITION, IS_FOLDER, LIST_INDEX, CREATED], where: '$LOCATION_ID = $locationId');
    List<Note> notes = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        notes.add(Note.fromJson(maps[i]));
      }
    }
    return notes;
  }
  
  // close database
  Future closeDb() async{
    var dbClient = await db;
    return dbClient.close();
  }




}