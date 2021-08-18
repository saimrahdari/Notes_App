import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class NoteEdit extends StatefulWidget {
  Note? note;

  NoteEdit({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {

  
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  String? _selectedName;
  String? date;
  var note_data_list = [];

   @override
    void initState() {
      super.initState();
      titleController.text = widget.note!.title;
      noteController.text = widget.note!.text;
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              String title = titleController.text;
                              String note = noteController.text;
                              var now = DateTime.now();
                              String formattedDate = DateFormat('MMMM dd,yyyy').format(now);
                              Note newNote = new Note(title: title, text: note, dateCreated: formattedDate);
      
                              note_data_list.add(newNote);
                              note_data_list.add(false);
                              note_data_list.add(false);
            
                              Navigator.pop(context, note_data_list);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 57, 57, 57),
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 17,
                                  ),
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 23,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _onButtonPressed(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 57, 57, 57),
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 29,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusColor: Colors.transparent,
                        hintStyle: TextStyle(
                            fontFamily: 'Flaunters',
                            fontSize: 50,
                            color: Color.fromARGB(255, 127, 127, 127)),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Flaunters',
                        fontSize: 40,
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(widget.note!.dateCreated, style: TextStyle(
                        color : Color.fromARGB(255, 127, 127, 127),
                        fontSize: 16,
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusColor: Colors.transparent,
                        hintText: 'Type something...',
                        hintStyle: TextStyle(
                            fontFamily: 'Flaunters',
                            fontSize: 25,
                            color: Color.fromARGB(255, 127, 127, 127)),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Flaunters',
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  void _onButtonPressed(context) {
    String title = titleController.text;
    String note = noteController.text;
    var now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd,yyyy').format(now);
    Note newNote = new Note(title: title, text: note, dateCreated: formattedDate);
    date = DateFormat('MMMM dd').format(now);

    showModalBottomSheet(context: context,
    backgroundColor: Color.fromARGB(255, 30, 28, 28),
    shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        
        )),
    builder: (BuildContext context) {  
      return Column(
        mainAxisSize : MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color : Colors.white),
            title: Text("Delete Note", style: TextStyle(color: Colors.white),),
            onTap: () {
              note_data_list.add(newNote);
              note_data_list.add(true);
              note_data_list.add(false);
              Navigator.pop(context);
              Navigator.pop(context, note_data_list);
            },
          ),
          ListTile(
            leading: Icon(Icons.copy, color : Colors.white),
            title: Text("Make a Copy", style: TextStyle(color: Colors.white),),
            onTap: () {              
              note_data_list.add(newNote);
              note_data_list.add(false);
              note_data_list.add(true);
              Navigator.pop(context);
              Navigator.pop(context, note_data_list);
            },
          ),
          ListTile(
            leading: Icon(Icons.share_rounded, color : Colors.white),
            title: Text("Share", style: TextStyle(color: Colors.white),),
            onTap: () {
              Share.share("${newNote.title} \n${newNote.text}");
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Center(child: Text("$date  |  ${newNote.text.length} characters", style: TextStyle(fontSize: 15, color: Colors.white30, fontFamily: 'GresaRegular'),)),
          ),
      ],);
    });
  }
}
