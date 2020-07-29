import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'storage.dart' as storage;

Map settings = {
  Keys.SAVE_ON_PHONE: true,
  Keys.SAVE_ON_CLOUD: true,
  Keys.USERNAME: 'Klodwig' 
};

AuthenticationBloc authenticationBloc = AuthenticationBloc();
LoginBloc loginBloc = LoginBloc();
String token;
// counts how much notes have been added
// used to generate note id 
int noteCount = 0;
void load() async {
  print(load.toString() + ' loading globals..');
  storage.getNoteCount().then((value) {
    noteCount = value;
    if (noteCount == null) { 
      storage.setNoteCount(0);
      noteCount = 0;
    }
    print(load.toString() + 'global note count: ' + value.toString()); 
  }); 
}


enum Keys{
  SAVE_ON_PHONE, SAVE_ON_CLOUD, USERNAME, NOTE_COUNT
}

enum Mode{
  ONLINE, OFFLINE
}

enum Errors{
  EMAIL_IN_USE, EMAIL_NOT_FOUND_OR_WRONG_PASSWORD, SOMETHING_ELSE
}

void setSetting(Keys key, value){ 
  settings[key] = value;
}