import 'package:RESTAPI/dbHelper.dart';
import 'package:RESTAPI/services/service.dart';
import 'package:RESTAPI/storage.dart' as storageManager; // sometimes its also called "storage"
import 'package:RESTAPI/views/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../styles.dart';
import 'package:json_annotation/json_annotation.dart';
import '../dbHelper.dart';
import 'folder.dart';
import 'note_states.dart';
import 'root.dart';
import '../views/note_fullscreen.dart';
part 'note.g.dart';
  // previews the note
  class NotePreview extends StatefulWidget {
    final Note note;

    // constructor
    NotePreview(this.note);

    @override
    _NotePreviewState createState() => _NotePreviewState(this.note);
  }

  class _NotePreviewState extends State<NotePreview> {
    Note note;
    double noteWidth;
    final GlobalKey textKey = GlobalKey();
    // constructor
    _NotePreviewState(this.note);
    

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [   
          Container(
            // color: Colorrs.getByName(note.color),
            child: Center(
              child:
                Text(
                  this.note.title,
                  key: textKey,
                  style: Styles.titlePreview
                )   
            )
          ),
          Positioned(  
            bottom: 15,
            right: 20,
            child: Text(  
              note.created,
              style: Styles.datePreview
            ),
          ),
        ]
      );
    }
  }

  // shows content of note
  class NoteDisplay extends StatefulWidget {
    Note note;
    Function setDisplayState;
    Function updateNote;
    Function deleteNote;

    NoteDisplay({this.note, this.setDisplayState, this.updateNote, this.deleteNote});
    @override  
    _NoteDisplay createState() => _NoteDisplay(this.note, this.setDisplayState, this.updateNote);
  }

    // Displays content of note and provides actions like delete
  class _NoteDisplay extends State<NoteDisplay> {
    final Note note; // the note that is shown
    Note noteCopy;
    final TextEditingController textController = new TextEditingController(); // user input
    final TextEditingController titleController = new TextEditingController(); // user input
    final Function setDisplayState;
    final Function updateNote;
    double screenWidth; // = width - padding of note

    _NoteDisplay(this.note, this.setDisplayState, this.updateNote);

    void _updateNote(){
      this.note.title = this.titleController.text;
      this.note.text = this.textController.text;
      print(this.textController.text);
      updateNote(this.note);
    }

    @override
    Widget build(BuildContext context) {
      this.screenWidth = MediaQuery.of(context).size.width;
      this.titleController.text = this.note.title;
      this.textController.text = this.note.text;
      this.titleController.addListener(_updateNote);
      this.textController.addListener(_updateNote);
      return Container(
        height: Sizes.noteOpenHeight,
        width: screenWidth,
        child: Stack(  
          children: [
            Positioned( 
              top: 10,
              child: Container(  
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: screenWidth - 17,
                child: TextField(
                  cursorColor: HexColor.fromHex(HexCodes.main),
                  controller: titleController,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  maxLength: 25,
                  style: Styles.text,
                  decoration: InputDecoration(  
                    focusedBorder: OutlineInputBorder(  
                      borderSide: BorderSide(  
                        color: Colors.transparent
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(  
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    hintText: 'title',
                    hintStyle: Styles.hint
                  )
                )
              )
            ),
            Positioned(
              top: 60,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: this.screenWidth - 17,
                height: 350, 
                  child: TextField( 
                    cursorColor: HexColor.fromHex(HexCodes.main),
                    controller: this.textController,
                    textAlign: TextAlign.left,
                    minLines: 1,
                    maxLines: 13,
                    style: Styles.text,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(  
                      focusedBorder: OutlineInputBorder(  
                        borderSide: BorderSide(  
                          color: Colors.transparent
                        )
                      ),
                      enabledBorder: OutlineInputBorder(  
                        borderSide: BorderSide(color: Colors.transparent)
                      )
                    )
                  )
                )
              ),
            Positioned( // delete button 
              bottom: 10,
              left: 5,
              child: MaterialButton(  
                height: 30,
                minWidth: 22,
                onPressed: () {
                  setDisplayState(StateKey.DELETE);
                },
                child: Center(child:Icon(Icons.delete, color: Colorrs.buttonIcon, size: Sizes.button,)),  
                color: Colorrs.getButtonColor(note.color, 'delete'),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white)
                ),
              ),
            ),
            
            Positioned( // expand size button
              bottom: 10,
              left: 45,
              child: MaterialButton(  
                height: 30,
                minWidth: 22,
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => NoteFullScreen(note: this.note, titleController: titleController, textController: textController, deleteNote: widget.deleteNote))
                  );
                },
                child: Center(child: Icon(Icons.fullscreen, color: Colorrs.buttonIcon, size: Sizes.button)),
                color: Colorrs.getButtonColor(note.color, 'scale'),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.white)
                )
              ),
            ),

            Positioned( // settings button
              bottom: 10,
              left: 85,
              child: MaterialButton(  
                height: 30,
                minWidth: 22,
                onPressed: (){
                  setDisplayState(StateKey.SETTINGS);
                },
                child: Center(child: Icon(Icons.settings, color: Colorrs.buttonIcon, size: Sizes.button)),
                color: Colorrs.getButtonColor(note.color, 'settings'),
                shape: CircleBorder( 
                  side: BorderSide(color: Colors.white)
                )
              ),
            ),
            Positioned( // date when the note was created
              bottom: 17,
              right: 20,
              child:Text(  
                note.created,
                style: Styles.date,
              )
            )
          ],
        ),
      );
    }
  }

  // container for note -> note.open == false: NotePreview
  //                    -> note.open == true: NoteDisplay
  class NoteBox extends StatefulWidget {
    final Note note;
    final Function updateSize;
    final Function onDelete;
    final Function updateLast;
    final Function select;
    Note noteCopy;
    Mode motherMode = Mode.VIEW;
    bool selectingFolder;
    final Function selectFolder;

    NoteBox(this.note, this.updateSize, this.onDelete, this.updateLast, this.motherMode, this.select, {this.selectingFolder: false, this.selectFolder}){
      this.noteCopy = Note(
        title: note.title, 
        text: note.text, 
        id: note.id, 
        created: note.created, 
        location_id: note.location_id, 
        locationDefinition: note.locationDefinition, 
        is_folder: note.is_folder,
        list_index: note.list_index,
        color: note.color);
    }

    @override
    _NoteBoxState createState() => _NoteBoxState();
  }

  class _NoteBoxState extends State<NoteBox> {
    Note note;
    Function updateSize;
    Function onDelete;
    Function select;
    // function used when pressing back button to get the changes
    Function updateLast;
    Service server = Service();
    Color _color;
    double _height = Sizes.noteClosedHeight;
    bool isPreview = true;
    DBHelper dbHelper = DBHelper();
    Mode motherMode; 

    @override
    void initState(){ 
      super.initState();
      select = widget.select;
      note = widget.note;
      updateSize = widget.updateSize;
      onDelete = widget.onDelete;
      updateLast = widget.updateLast;
      motherMode = widget.motherMode;
    }

// Function to set Display Mode of Notes
    void setDisplayState(StateKey state){
      setState(() {
        note.setDisplayState(state);
      });
    }

// Function to update Note on DB and Server 
// note is not updateable when the text inside of the TextController gets deleted 
    void updateNote(Note note){
      if(!this.note.updateable) return;
      this.note = note;
      storageManager.handleNoteStorage(note, storageManager.Action.UPDATE);
    }

    void _select(){
      print(widget.motherMode.toString());
      note.is_folder == 0 ?
        select(note) 
        : motherMode == Mode.SELECT_FOLDER ? widget.selectFolder(note) : select(note); 
    }

    void _updateState(){
      setState(() {
        if(!note.open){ 
          note.open = !note.open;
          note.setDisplayState(StateKey.DISPLAY);
          updateSize();
          _height = Sizes.noteOpenHeight;
          _color = Colorrs.getByName(note);
        }
        else {
          server.updateNote(note);
          note.open = !note.open;
          note.setDisplayState(StateKey.CLOSED);
          updateSize();
          _height = Sizes.noteClosedHeight;
          _color = Colorrs.getByName(note);
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      
      this._color = Colorrs.getByName(note);
      if (this.note.open){
        _height = Sizes.noteOpenHeight;
      }

      return GestureDetector(
        onTap: note.is_folder == 0 ? motherMode == Mode.VIEW ? () { // if Mode of Root / Folder is View note is editable 
          this.note.updateable = !this.note.updateable; // if Mode of Root / Folder is SELECT select callback of Root / Folder is called
          _updateState();
        } : _select : motherMode == Mode.VIEW ? () { 
          if (!note.open) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Folder(this.note, this.updateLast))
            );
          } else { 
             this.note.updateable = !this.note.updateable; // if Mode of Root / Folder is SELECT select callback of Root / Folder is called
            _updateState();
          }
        } : _select,
        onDoubleTap: _select,
        // borderRadius: BorderRadius.all(Radius.circular(30)),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 10),
          height: _height,
          decoration: BoxDecoration(  
            border: Border.all(color: !note.states[StateKey.SELECTED] ?  Colorrs.borderColor : Colorrs.noteSelected, width: 2),
            color:  _color,
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: Stack(
            children: [
                note.is_folder == 0 ? 
                Stack( 
                  children: [
                    Visibility(  
                      visible: !note.open,
                      child: NotePreview(note)
                    ),
                    Visibility( 
                      visible: note.states[StateKey.DISPLAY],
                      child: NoteDisplay(
                        note: note, 
                        setDisplayState: setDisplayState, 
                        updateNote: updateNote, 
                        deleteNote: onDelete
                      ),
                    ),
                    Visibility(
                      visible: note.states[StateKey.SETTINGS],
                      child: NoteSetting(note, widget.noteCopy, setDisplayState),
                    ),
                    Visibility(  
                      visible: note.states[StateKey.DELETE],
                      child: DeleteNoteDisplay(note, setDisplayState, onDelete),
                    ),  
                    Visibility(
                      visible: note.states[StateKey.COLOR_PICKER],
                      child: CustomColorDisplay(widget.noteCopy, setDisplayState)
                    )
                  ]
                ) : 
                Stack(  
                  children: [
                      Stack(  
                        children: [
                          Visibility(  
                            visible: !this.note.open,
                            child: FolderPreview(note, updateLast, setDisplayState, _updateState, motherMode, select),
                          ),
                          Visibility(  
                            visible: this.note.states[StateKey.DISPLAY],
                            child: FolderDisplay(folder: this.note, updateFolder: this.updateNote, setDisplayState: setDisplayState, update: _updateState)
                          ),
                          Visibility(  
                            visible: this.note.states[StateKey.COLOR_PICKER],
                            child: CustomColorDisplay(widget.noteCopy, setDisplayState)
                          ),
                          Visibility(
                            visible: note.states[StateKey.SETTINGS],
                            child: FolderDisplay(folder: this.note, updateFolder: this.updateNote, setDisplayState: setDisplayState, update: _updateState),
                          ),
                        ]
                      )    
                    ]
                  )
                ]
          )
        )
      );
    }
  }

enum StateKey {
  SETTINGS, DELETE, DISPLAY, COLOR_PICKER, OPEN, CLOSED, SELECTED
}
@JsonSerializable()
class Note {
  int id;
  String title;
  String text;
  String color = HexCodes.standardNote;
  String created;
  int location_id;
  int locationDefinition;
  int list_index;
  int is_folder;
  bool open = false;
  bool updateable = false;
  Map states = {StateKey.SETTINGS: false, StateKey.DISPLAY: false, StateKey.COLOR_PICKER: false, StateKey.DELETE: false, StateKey.OPEN: false, StateKey.SELECTED: false}; 

  void setDisplayState(StateKey state){
    states.keys.forEach((element) => states[element] = false);
    if (state == StateKey.CLOSED) return;
    states[state] = true;
  }

  Note({this.title, this.text, this.id, this.created, this.location_id, this.locationDefinition, this.is_folder, this.list_index, this.color});
    
  factory Note.fromJson(Map<String,dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}


class NoteSetting extends StatefulWidget {
  final Note note;
  final Note noteCopy;
  final Function setDisplayState;

  NoteSetting(this.note, this.noteCopy, this.setDisplayState);
  @override
  _NoteSettingState createState() => _NoteSettingState();
}

class _NoteSettingState extends State<NoteSetting> {
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ColorSettings(widget.note, widget.noteCopy, widget.setDisplayState),
          Positioned(
            bottom: 20,
            right: 25,
            child: MaterialButton( 
              onPressed: (){
                widget.note.color = widget.noteCopy.color;
                storageManager.handleNoteStorage(widget.note, storageManager.Action.UPDATE);
                widget.setDisplayState(StateKey.DISPLAY);
              },
              child: Text(  
              'confirm',
              style: Styles.text,
              )
            )
          ),
          Positioned(
            bottom: 20,
            left: 25,
            child: MaterialButton(  
              onPressed: (){
                widget.setDisplayState(StateKey.DISPLAY);
              },
              child: Text(  
                'back',
                style: Styles.backButtonText,
                textAlign: TextAlign.left,
              )
            )
          )
        ],
      )
    );
  }
}
class DeleteNoteDisplay extends StatefulWidget {
  final Note note;
  final Function setDisplayState;
  final Function delete;

  DeleteNoteDisplay(this.note, this.setDisplayState, this.delete);

  @override
  _DeleteNoteDisplayState createState() => _DeleteNoteDisplayState(this.note, this.setDisplayState, this.delete);
}

class _DeleteNoteDisplayState extends State<DeleteNoteDisplay> {
  final Note note;
  final Function setDisplayState;
  final Function delete;

  _DeleteNoteDisplayState(this.note, this.setDisplayState, this.delete);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(  
        children: [
          Positioned(  
            bottom: 20,
            right: 25,
            child: MaterialButton(
              onPressed: ((){
                delete(note);
                setDisplayState(StateKey.DISPLAY);
              }),  
              child: Text(
                'delete',
                style: Styles.deleteNoteConfirm
              ),
            ),
          ),
          Positioned(   
            bottom: 20,
            left: 25,
            child: MaterialButton(  
              onPressed:((){
                setDisplayState(StateKey.DISPLAY);
              }),
              child: Text(  
                'no', 
                style: Styles.backButtonText,
              ),
            ),
          ),
          Center(  
            child: Text(  
              'are you sure about that?',
              style: Styles.titlePreview,
            ),
          )
        ],
      ),
    );
  }
}

class FolderPreview extends StatefulWidget {
  final Note folder;
  final Function updateLast;
  final Function setDisplayState;
  final Function updateState; // needed because onTap method isnt executed in Note box 
  final Function select;
  Mode motherMode;

  FolderPreview(this.folder, this.updateLast, this.setDisplayState, this.updateState, this.motherMode, this.select);

  @override
  _FolderPreviewState createState() => _FolderPreviewState(this.folder, this.updateLast, this.setDisplayState, this.updateState);
}

class _FolderPreviewState extends State<FolderPreview> {
  final Note folder;
  final Function updateLast;
  final Function setDisplayState;
  final Function updateState;
  Function select;

  _FolderPreviewState(this.folder, this.updateLast, this.setDisplayState, this.updateState);

  void initState(){
    super.initState();
    select = widget.select;
  }

  void _select(){
    select(folder);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.motherMode == Mode.VIEW ? (){
        if(folder.is_folder == 1 && !folder.open) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Folder(this.folder, this.updateLast))
          );
        } 
        else {
          setDisplayState(StateKey.CLOSED);
          this.folder.updateable = !this.folder.updateable; // like in Note Box
          updateState();
        }
      } : _select,
      child: (
        Stack(  
          children: [
            Positioned(
              top: 10,
              left: 20, 
              child: Icon(Icons.folder, color: Colors.white, size: 75)
            ),
            Positioned(
              left: 100,
              top: Sizes.noteClosedHeight /2 - 15,
              child: Container( 
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: Text(
                    folder.title,
                    style: Styles.titlePreview, 
                    textAlign: TextAlign.right, 
                  )     
                )
              )
            ),
            Positioned( 
              right: 0,
              top: 1.7,
              child: MaterialButton(
                onPressed: (){
                  setDisplayState(StateKey.DISPLAY);
                  this.folder.updateable = !this.folder.updateable; // like in Note Box
                  updateState();
                },
                height: 40,
                minWidth: 40,  
                child: Icon(Icons.settings, color: Colorrs.buttonIcon, size: 20),
              )
            ),
            Positioned(  
              bottom: 15,
              right: 20,
              child: Text(  
                folder.created,
                style: Styles.datePreview
              )
            )
          ]
        )
      )
    );
  }
}

class FolderDisplay extends StatefulWidget {
  final Note folder; 
  final Function updateFolder;
  final Function setDisplayState;
  final Function update;

  FolderDisplay({this.folder, this.updateFolder, this.setDisplayState, this.update});

  @override
  _FolderDisplayState createState() => _FolderDisplayState(this.folder, this.updateFolder);
}

class _FolderDisplayState extends State<FolderDisplay> {
  DBHelper dbHelper = DBHelper();
  Note folder;
  Function updateFolder; 
  TextEditingController titleController = TextEditingController();


  _FolderDisplayState(this.folder, this.updateFolder){
    titleController.addListener(_updateFolder); 
    titleController.text = folder.title;
  }

    void _updateFolder(){
      this.folder.title = this.titleController.text;
      updateFolder(this.folder);
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.noteOpenHeight,
      width: MediaQuery.of(context).size.width,
      child: Stack(  
        children: [
          ColorSettings(widget.folder, widget.folder, widget.setDisplayState),
          Positioned(
            bottom: 10,
            left: 5,
            child: MaterialButton(  
              height: 30,
              minWidth: 22,
              onPressed: (){  
              },
              child: Center(child: Icon(Icons.delete, color: Colorrs.buttonIcon, size: Sizes.button)),
              color: Colorrs.getButtonColor(folder.color, 'delete'),
              shape: CircleBorder(
                side: BorderSide(  
                  color: Colors.white
                )
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Container(  
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: MediaQuery.of(context).size.width - 17,
              child: TextField(  
                controller: titleController,
                textAlign: TextAlign.center,
                maxLines: 1,
                maxLength: 25,
                style: Styles.text,
                decoration: InputDecoration(  
                  focusedBorder: OutlineInputBorder(  
                    borderSide: BorderSide(  
                      color: Colors.transparent
                    )
                  ),
                  enabledBorder: OutlineInputBorder(  
                    borderSide: BorderSide(color: Colors.transparent
                    )
                  ),
                  hintText: 'title',
                  hintStyle: Styles.hint
                ),
              ),
            ),
          ),  
            Positioned(
              bottom: 20,
              right: 25,
              child: MaterialButton( 
                onPressed: (){
                  storageManager.handleNoteStorage(widget.folder, storageManager.Action.UPDATE);
                  widget.setDisplayState(StateKey.CLOSED);
                  widget.folder.updateable = !widget.folder.updateable; 
                  widget.update();
                },
                child: Text(  
                'confirm',
                style: Styles.text,
                )
              )
            ),
          ],
      ),
    );
  }
}