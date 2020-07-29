import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/storage.dart' as storageManager;
import 'package:RESTAPI/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final storage = new FlutterSecureStorage();
  Service server = Service();

  Future<List<String>> authenticate({
    @required String email,
    @required String password,
  }) async{
    await Future.delayed(Duration(seconds: 1));
    return [email, password];
  }

  Future<void> signup({String name, @required String email, @required String password, @required String token}) async {
      storage.write(key: 'name', value: name);
      storage.write(key: 'email', value: email);
      storage.write(key: 'password', value: password);
      storage.write(key: 'token', value: token);
  }
  
  Future<void> deleteToken() async{
    await storage.delete(key: 'name');
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    await storage.delete(key: 'token');
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String email, String password, String token) async {
    /// write to keystore/keychain
    await storage.write(key: 'email', value: email);
    await storage.write(key:'password', value: password);
    await storage.write(key: 'token', value: token);
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    // using email for validation if user is already logged in
    String token = await storage.read(key: 'token'); 
    globals.token = token; // updates the global token 
    /// read from keystore/keychain
    if(token != null){ print(token);return true;}
    return false;
  }
  
  Future<String> getToken() async { 
    String token = await storage.read(key: 'token');
    globals.token = token;
    return token;
  }

  Future<void> setOffline() async { 
    await storage.write(key: 'token', value: 'Gertrude');
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(globals.Keys.SAVE_ON_CLOUD.toString(), false);
    globals.setSetting(globals.Keys.SAVE_ON_CLOUD, false);
    _prefs.setBool(globals.Keys.SAVE_ON_PHONE.toString(), true);
    globals.setSetting(globals.Keys.SAVE_ON_PHONE, true);
  }
}

