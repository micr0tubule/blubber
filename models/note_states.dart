

import 'package:RESTAPI/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'note.dart';


class CustomColorDisplay extends StatefulWidget {
  final Note note;
  final Function setDisplayState;

  CustomColorDisplay(this.note, this.setDisplayState);
  @override
  _CustomColorDisplayState createState() => _CustomColorDisplayState();
}

class _CustomColorDisplayState extends State<CustomColorDisplay> {
  Color currentColor = Colors.limeAccent;

  
  void changeColor(Color color){
    currentColor = color;
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
      Container(
      child: ColorPicker(
        enableAlpha: false,
        onColorChanged: changeColor,
        pickerAreaBorderRadius: BorderRadius.all(Radius.circular(28)),
        pickerColor: HexColor.fromHex(widget.note.color),
        pickerAreaHeightPercent: 6,
        colorPickerWidth: 75.001,
        pickerAreaWidthPercent: 6,
        hueTop: 390,
        hueRight: 45,
        showLabel: false,
      )),
      
      Positioned(
        bottom: 8,
        right: -14,
         child: FlatButton (  
          onPressed: (){
            widget.note.color = currentColor.toHex();
            widget.setDisplayState(StateKey.SETTINGS);
          },
          child: Center(child: Icon(Icons.check, color: Colors.white, size: Sizes.button)),
          color: Colors.black,
          shape: CircleBorder( 
            side: BorderSide(color: Colors.white)
          )
        ),
      ),
      ]);
  }
}