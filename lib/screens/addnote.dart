import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {

  List? notesList;

  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  
  final titleController = TextEditingController();
  final noteController = TextEditingController();

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
                            Note? newNote;
                            Navigator.pop(context, newNote);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 57, 57, 57),
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                            ),
                            child: Row(
                              children: const [
                                SizedBox(
                                  width: 17,
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String title = titleController.text;
                            String note = noteController.text;
                            var now = DateTime.now();
                            String formattedDate = DateFormat('MMMM dd,yyyy').format(now);
                            Note newNote = new Note(title: title, text:  note, dateCreated: formattedDate);
      
                            Navigator.pop(context, newNote);
                          },
                          child: Container(
                            width: 90,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 57, 57, 57),
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                            ),
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GresaRegular',
                                  fontSize: 18,
                                ),
                              ),
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
                      hintText: 'Title',
                      hintStyle: TextStyle(fontFamily: 'Flaunters', fontSize: 50, color: Color.fromARGB(255, 127, 127, 127)),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Flaunters',
                      fontSize: 40,
                      color: Colors.white
                    ),
                    cursorColor: Colors.white,
                  ),
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
                      hintStyle: TextStyle(fontFamily: 'Flaunters', fontSize: 25, color: Color.fromARGB(255, 127, 127, 127)),
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
}
