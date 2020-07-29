import 'package:flutter/material.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'package:RESTAPI/styles.dart';



class ButtonSetting extends StatefulWidget {

  ButtonSetting({
    this.description, 
    this.onPressed,
    this.color
  });

  final String description;
  final Function onPressed;
  final Color color;

  @override
  _ButtonSettingState createState() => _ButtonSettingState();
}

class _ButtonSettingState extends State<ButtonSetting> {
  @override
  Widget build(BuildContext context) {
    return InkWell( 
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onPressed,
      child: Container(
        width: 380,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration( 
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
        ),
        child: Center( 
          child: Container( 
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Text(
              widget.description,
              style: Styles.loginButton,
            ),
          ),
        )
      )
    );
  }
}