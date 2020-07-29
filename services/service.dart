
import 'dart:convert';
import 'package:RESTAPI/globals.dart' as globals;
import 'package:RESTAPI/services/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:RESTAPI/models/note.dart';
import 'signup_response.dart';

class Service{
  final String _signup = '/signup';
  final String _login = '/login';
  final String notesGet = '/notes/get';
  final String notesSave = '/notes/save';
  final String notesUpdate = '/notes/update';
  final String notesDelete = '/notes/delete';
  final String notesCount = '/notes/count';
  final String notesById = '/notes/byId';

  final String url = 'http://have.pythonanywhere.com';
  final String tokenHeader = 'Bearer ';
  final String token = globals.token;

  Future<List> getNotes({int location}) async{
    if (location != null){ // when location is specified get only notes for that location 
      Response res = await post(url + notesGet, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode({'location': location}));
      Map<String, dynamic> body = jsonDecode(res.body);
      return body["notes"] != null ?  
      body["notes"].map((dynamic item) => Note.fromJson(item)).toList() : [];
    } // else get all notes
    else{
      Response res = await get(url + notesGet, headers: {'Authorization': tokenHeader + globals.token});
      Map<String, dynamic> body = jsonDecode(res.body);
      return body["notes"] != null ?  
      body["notes"].map((dynamic item) => Note.fromJson(item)).toList() : [];
    }
  }

  Future<void> saveNote(Note note) async {
    await post(url + notesSave, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode(note.toJson()));
  }

  Future<void> updateNote(Note note) async {
    await post(url + notesUpdate, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode(note.toJson()));
  }
  Future<void> deleteNote(Note note) async {
    await post(url + notesDelete, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode(note.toJson()));
  }
  
  Future<SignUpResponse> signup(String name, String email, String password) async{
    Response res = await post(
      url + _signup,
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'password': password      
      })
    );
    if (res.statusCode == 200){
      Map<String, dynamic> body = jsonDecode(res.body);
      var data = body['signUpResponse'];
      return data.map((dynamic item) => SignUpResponse.fromJson(item)).toList()[0]; 
    }
    return SignUpResponse('4');
  }

  Future<LoginResponse> login(String email, String password) async{
     Response res = await post(
      url + _login,
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password      
      })
    );
      if (res.statusCode == 200){
        Map<String, dynamic> body = jsonDecode(res.body);
        var data = body['loginResponse'];
        return data.map((dynamic item) => LoginResponse.fromJson(item)).toList()[0];
      }
      else{
        return LoginResponse('4');
      }
  }

  Future<bool> updateToken(){
    String email;
    String password;
    FlutterSecureStorage storage = FlutterSecureStorage();
    storage.read(key: 'email').then((value){
      email = value;
      storage.read(key: 'password').then((value){
        password = value;
        login(email, password).then((value) {
          if(value.message == '0'){
            storage.write(key:'token', value: value.token);
          }
        });
      });
    });
    return Future<bool>.value(true);
  }

  Future<int> getNoteCount() async {
    Response res = await get(url + notesCount, headers: {'Authorization': tokenHeader + globals.token});
    if (res.statusCode == 200){
      Map<String, dynamic> body = json.decode(res.body);
      var data = body['note_count']['note_count'];
      print('note count: ' + data.toString());
      return data == null ? 0 : data;
    }
  }

  Future<void> setNoteCount(count) async { 
    await post(url + notesCount, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode({'note_count': count})); 
  }

  Future<Note> getNoteById(int id) async{
    Response res = await post(url + notesById, headers: {'Authorization': tokenHeader + globals.token}, body: jsonEncode({'id': id}));

  }
}

