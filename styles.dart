import 'package:flutter/material.dart';
import 'package:RESTAPI/models/note.dart';

class Styles{
  static final TextStyle text = new TextStyle(
    color: Colorrs.text,
    fontFamily: Fonts.standard,
    fontSize: 15
  );

  static final TextStyle textBlack = new TextStyle(
    color: Colorrs.textBlack,
    fontFamily: Fonts.standard,
    fontSize: 20
  );
  static final TextStyle hint = new TextStyle(   
    color: Colorrs.hint,
    fontSize: 20
  );
  static final TextStyle date = new TextStyle(  
    color: Colorrs.date,
    fontSize: 14,
    fontFamily: Fonts.standard
  );
  static final TextStyle datePreview = new TextStyle(
    color: Colorrs.previewDate,
    fontSize: 14,
    fontFamily: Fonts.standard
  );
  
  static final TextStyle titlePreview = new TextStyle(  
    color: Colorrs.text,
    fontSize: 20,
    fontFamily: Fonts.standard,
    fontWeight: FontWeight.bold
  );

  static final TextStyle loginInput = new TextStyle(  
    color: Colorrs.loginInputHint,
    fontSize: Sizes.loginInputHint, 
    fontFamily: Fonts.standard
  );

  static final TextStyle errorMessage = new TextStyle(
    color: Colorrs.deleteNote,
    fontSize: Sizes.errorMessage,
    fontFamily: Fonts.standard
  );


  static final InputDecoration inputField = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide(  
        color: Colors.transparent
      )
    )
  );

  static final TextStyle loginHeader = new TextStyle(  
    color: Colorrs.loginHeader,
    fontFamily: Fonts.standard,
    fontWeight: FontWeight.bold,  
    fontSize: 30
  );

  static final TextStyle loginButton = new TextStyle(  
    color: Colorrs.loginButtonText,  
    fontFamily: Fonts.standard,
    fontWeight: FontWeight.bold,
    fontSize: Sizes.standardFont
  );

  static final TextStyle loginSwitchButton = new TextStyle(  
    color: Colorrs.loginRegisterButton,
    fontFamily: Fonts.standard
  );

  static final TextStyle settings = new TextStyle(  
    color: Colorrs.text,
    fontFamily: Fonts.standard,
    fontSize: Sizes.standardFont,
    fontWeight: FontWeight.bold
  );

  static final TextStyle backButtonText = new TextStyle(  
    color: Colorrs.text,
    fontFamily: Fonts.standard,
    fontSize: Sizes.standardFont
  );

  static final TextStyle deleteNoteConfirm = new TextStyle(  
    color: Colorrs.deleteNote,
    fontFamily: Fonts.standard,
    fontSize: Sizes.standardFont
  );
  
  static final TextStyle folderTitleText = new TextStyle(  
    color: Colorrs.text, 
    fontFamily: Fonts.standard, 
    fontSize: 20
  );
}

class Decorations{
  static final InputDecoration nameInput = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide(  
        color: Colorrs.loginInputBorder
      )
    ),
    hintText: 'name',
    hintStyle: Styles.loginInput 
  );

  // email input decoration 
  static final InputDecoration emailInput = new InputDecoration(
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide(  
        color: Colorrs.loginInputBorder
      )
    ),
    hintText: 'email',
    hintStyle: Styles.loginInput  
  );

  // password input decoration
  static final InputDecoration passwordInput = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide(  
        color: Colorrs.loginInputBorder
      )
    ),
    hintText: 'password',
    hintStyle: Styles.loginInput  
  );

  // password input decoration
  static final InputDecoration passwordConfirmInput = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide(  
        color: Colorrs.loginInputBorder
      )
    ),
    hintText: 'confirm',
    hintStyle: Styles.loginInput  
  );

  static final InputDecoration changeTitleOfFolder = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide( 
        color: Colorrs.loginInputBorder
      ) 
    ),
    hintText: 'title',
    hintStyle: Styles.hint
  );

  static final InputDecoration searchInput = new InputDecoration(  
    focusedBorder: OutlineInputBorder(  
      borderSide: BorderSide( 
        color: Colorrs.loginInputBorder
      ) 
    ),
    hintText: 'search',
    hintStyle: Styles.hint
  );

  //   // confirm password input decoration
  // static final InputDecoration confirmPasswordInput = new InputDecoration(  
  //   focusedBorder: OutlineInputBorder(  
  //     borderSide: BorderSide(  
  //       color: Colorrs.loginInputBorder
  //     )
  //   ),
  //   hintText: 'confirm',
  //   hintStyle: Styles.loginInput  
  // );
 
}
class Colorrs{
  static final Color background = Colors.black;
  static final Color text = Colors.white;
  static final Color buttonIcon = Colors.white;
  static final Color hint = Colors.grey;
  static final Color scaleNote = HexColor.fromHex('#6200EE');
  static final Color deleteNote = HexColor.fromHex('#ff0800');
  static final Color noteSetting = HexColor.fromHex('#3700B3');
  static final Color addNote = Colors.black;// HexColor.fromHex('#6200ee');
  static final Color addNoteIcon = Colors.white;
  static final Color date = Colors.white;
  static final Color borderColor = Colors.white;
  static final Color previewDate = Colors.white;
  static final Color loginPageBackground = Colors.black;
  static final Color loginInputHint = Colors.grey;
  static final Color loginInputBorder = Colors.transparent;
  static final Color loginButton = HexColor.fromHex('#6200ee');
  static final Color textBlack = Colors.black;
  static final Color loginHeader = Colors.white;
  static final Color loginRegisterButton = Colors.white;
  static final Color loginButtonText = Colors.white;
  static final Color noteStandard = Colors.black;
  static final Color green = HexColor.fromHex('#652EC7');
  // static final Color red = HexColor.fromHex('#3700b3');
  static final Color blue = HexColor.fromHex('#03DAC6');
  static final Color yellow = HexColor.fromHex('#018786');
  static final Color goToLastFolder = Colorrs.green;
  static final Color missingInput = Colorrs.deleteNote;
  static final Color checkboxActive = Colors.white;
  static final Color noteSelected = HexColor.fromHex(HexCodes.main);

  static Color getByName(Note note){
    if(!note.open){ 
      return HexColor.fromHex(note.color);
    }
    else{
      return Colors.black;
    }
  }

  static Color getButtonColor(String backgroundColor, String button){
  //   if(backgroundColor == ''){
      if(button == 'settings'){
        return Colorrs.noteSetting;
      }
      else if(button == 'scale'){
        return Colorrs.scaleNote;
      }
      else if(button == 'delete'){
        return Colorrs.deleteNote;
      }
      return Colors.black;
  }
}

class HexCodes {
  static final String standardNote = '#000000';
  static final String main = '#3700b3';
  static final String mainContrast = '#652EC7';
  static final String secondary = '#03DAC6';
  static final String secondaryContrast = '#018786';
}

 
class Fonts{
  static final String standard = 'RobotoMono';
}

class Sizes{
  static final double button = 20;
  static final double noteOpenHeight = 450;
  static final double noteClosedHeight = 100;
  static final double noteSpace = 18;
  static final double buttonCorner = 18;
  static final double loginPaddingAll = 5;
  static final double loginInputHint = 15;
  static final double standardFont = 15;
  static final double addNoteOffset = 1000;
  static final double errorMessage = 11;
  double noteWidth = 0;

  void setNoteWidth(double noteWidth){
    this.noteWidth = noteWidth;
  }
  double getNoteWidth(){
    return this.noteWidth;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

