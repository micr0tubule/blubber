import 'package:flutter/material.dart';
import 'package:RESTAPI/globals.dart' as globals;
import 'package:RESTAPI/styles.dart';

class OnOffSetting extends StatefulWidget {

  OnOffSetting({this.description, this.onChanged, this.value});

  final String description;
  final Function onChanged;
  final bool value;

  @override
  _OnOffSettingState createState() => _OnOffSettingState();
}

class _OnOffSettingState extends State<OnOffSetting> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration( 
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2)
      ),
      child: Row(  
        children: <Widget>[ 
          Container( 
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              widget.description,
              style: Styles.text,
            ),
          ),
          Expanded( 
            child: Align(
              alignment: Alignment.centerRight,
              child: Container( 
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Transform.scale(  
                    scale: 0.85,
                    child: Switch(
                      activeTrackColor: HexColor.fromHex(HexCodes.mainContrast),
                      activeColor: Colors.white,
                      focusColor: Colors.white,
                      value: widget.value,
                      onChanged: (value) { 
                        widget.onChanged(value);
                      }
                    )
                  )
                )
              )
            )
          )
        ],
      ),
    );
  }
}