import 'package:RESTAPI/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'note_fullscreen.dart';
import 'package:RESTAPI/storage.dart' as storage;
import '../models/note.dart'; 
import 'package:RESTAPI/styles.dart';
import 'package:RESTAPI/DatePicker/widget/date_picker_widget.dart';
import 'package:RESTAPI/TimePicker/flutter_time_picker_spinner.dart';


class SetNotificationScreen extends StatefulWidget {
  final Note note;

  SetNotificationScreen({this.note});

  @override
  _SetNotificationScreenState createState() => _SetNotificationScreenState();

}

class _SetNotificationScreenState extends State<SetNotificationScreen> {
  Future onDidReceiveLocalNotification(int id, String head, String body, String payload) async {
  storage.getNoteById(0).then((value){
    showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(head),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteFullScreen(note: value),
                ),
              );
            },
          )
        ],
      ));
    });
  }


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettings;
  var initializationSettingsAndroid;
  var initializationSettingsIOS;

  var androidPlatformChannelSpecifics;
  var iOSPlatformChannelSpecifics;
  var platformChannelSpecifics;

  var scheduleNotificationDateTime;

  DateTime currentSelectedTime = DateTime.now();
  DateTime currentSelectedDate = DateTime.now();

  void setCurrentSelectedTime(DateTime time){
    print('hja');
    currentSelectedTime = time;
  }

  void setCurrentSelectedDate(DateTime time) { 
    print('object');
    currentSelectedDate = time;
  }

  void scheduleNotification(DateTime scheduleNotificationDateTime) async { 
    await flutterLocalNotificationsPlugin.schedule(  
      0,
      widget.note.title, 
      '', 
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true
    );
  }


  @override 
  void initState() {
    super.initState();
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    androidPlatformChannelSpecifics =  AndroidNotificationDetails( 
      '0', 'reminders', 'reminders that remind of something',
      importance: Importance.Max, 
      priority: Priority.High, 
      ticker: widget.note.title
    );
    iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails( 
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics
    );
  }

  DateTime fuseDateAndTime(DateTime date, DateTime time) { 
    return DateTime(date.year, date.month, date.day, time.hour, time.minute); 
  }

  showDatePicker(BuildContext context) { 
    return showDialog(context: context, builder: (context) {
      return AlertDialog(  
        content: Stack(  
          children: [
            Center(  
              child: Container(
                decoration: BoxDecoration( 
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                ),
                width: 300, 
                height: 350,
                child: Column(  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DatePickerWidget(      
                      initialDate: DateTime.now(),
                      currentSelectedDate: currentSelectedDate,
                      setCurrentSelectedDate: setCurrentSelectedDate,
                    ),
                    Container( 
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: TimePickerSpinner(
                        is24HourMode: false,
                        setCurrentSelectedTime: setCurrentSelectedTime,
                      )
                    ),
                    Align(  
                      alignment: FractionalOffset.bottomLeft,
                      child: Container(  
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: (){
                            Navigator.pop(context);
                          },  
                          child: Text(  
                            'back',
                            style: Styles.loginSwitchButton,
                          ),
                        )
                      )
                    ),
                    Align(  
                      alignment: FractionalOffset.bottomRight,
                      child: Container(  
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: (){
                            scheduleNotification(fuseDateAndTime(currentSelectedDate, currentSelectedTime));
                            Navigator.pop(context);
                          },  
                          child: Text(  
                            'yes',
                            style: Styles.loginSwitchButton,
                          ),
                        )
                      )
                    ),
                  ],
                )
              )
            ),
          ]),
        );
      });
  }
  @override
  Widget build(BuildContext context) {

    // scheduleNotification(DateTime.now().add(Duration(seconds: 2)));
    // return Scaffold(  
      // appBar: AppBar(  
      //   title: Text(  
      //     'notification',
      //     style: Styles.titlePreview,
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colorrs.background,
      // ),
      // backgroundColor: Colorrs.background,
      return
        AlertDialog( 
        backgroundColor: Colors.transparent,
        content: Container( 
          decoration: BoxDecoration( 
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
          ),
          width: 300,
          height: 330,
          child: Stack(  
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),

              child: Column(  
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DatePickerWidget(  
                    
                    initialDate: DateTime.now(),
                    currentSelectedDate: currentSelectedDate,
                    setCurrentSelectedDate: setCurrentSelectedDate,
                    
                  ),
                  Container( 
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: TimePickerSpinner(
                      is24HourMode: false,
                      setCurrentSelectedTime: setCurrentSelectedTime,
                    )
                  ),
     
                ],
              )
            ),
          
                     Align(  
            alignment: FractionalOffset.bottomLeft,
            child: Container(  
              padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
              child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  Navigator.pop(context);
                },  
                child: Text(  
                  'cancel',
                  style: Styles.loginSwitchButton,
                ),
              )
            )
          ),
               
                Align(  
            alignment: FractionalOffset.bottomRight,
            child: Container(  
              
              padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
              child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  scheduleNotification(fuseDateAndTime(currentSelectedDate, currentSelectedTime));
                  Navigator.pop(context);
                },  
                child: Text(  
                  'confirm',
                  style: Styles.loginSwitchButton,
                ),
              )
            )
          ),
       
        ],
        
        )

      ),
    );
  }
}

