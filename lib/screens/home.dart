import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/user_prefrences.dart';
import 'package:notes_app/screens/addnote.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/screens/noteedit.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List <Note> notesList = [];
  List <Note> searchedNotesList = [];
  var searchedNotesIndex = [];

  bool searchNote = false;
  bool isSearched = false;
  int searchedNoteIndex = 0;
  Note? searchedNote;
  Note? newNote, oldNote;
  var noteDataList;
  final searchController = TextEditingController();

   @override
  void initState() {
    super.initState();
    
    String? name = UserPrefrences.getNotes();
    if(name != null)
      notesList = UserPrefrences.decode(name);
  }

  @override
  Widget build(BuildContext context) {
    return searchNote
        ? GestureDetector(
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
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          searchNote = !searchNote;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
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
                                Icon (
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: TextField(
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusColor: Colors.transparent,
                            hintText: 'Search Here',
                            hintStyle: TextStyle(
                                fontFamily: 'Flaunters',
                                fontSize: 50,
                                color: Color.fromARGB(255, 127, 127, 127)),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Flaunters',
                            fontSize: 40,
                            color: Color.fromARGB(255, 127, 127, 127),
                          ),
                          showCursor: false,
                          onChanged: (text) {
                            Note? noteToBeSearched;
                            searchedNotesList.clear();
            
                            for(int i = 0; i < notesList.length; i++){
                              noteToBeSearched = notesList.elementAt(i);
                              if(noteToBeSearched.title.toLowerCase().contains(text.toLowerCase())){
                                searchedNoteIndex = i;
                                isSearched = true;
                                searchedNotesList.add(notesList.elementAt(i));
                                searchedNotesIndex.add(i);
                              }
                            }
                            if(searchController.text == "")
                              isSearched = false;
                            else if(isSearched)
                              searchedNote = noteToBeSearched;
            
                              setState(() {});
                            }
                        ),
                      ),
                      SizedBox(height: 30,),
                      isSearched ? 
                      Expanded(
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: searchedNotesList.length,
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
            
                                for(int i = 0; i < searchedNotesIndex.length; i++){
                                  print(searchedNotesIndex.length);
                                  print("Hello");
                                  print(searchedNotesIndex.elementAt(i));
                                } 
            
                                final res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NoteEdit(note: notesList[searchedNotesIndex.elementAt(index)])),
                                );
                                searchController.text = "";
                                searchNote = false;
                                isSearched = false;
                                noteDataList = res;
                                newNote = noteDataList[0];
            
                                  if(noteDataList[1] == true){
                                    notesList.removeAt(searchedNotesIndex.elementAt(index));
                                    Fluttertoast.showToast(
                                    msg: "Note Deleted Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                  }
                                  else if(noteDataList[2] == true){
                                    notesList.add(newNote!);
                                    Fluttertoast.showToast(
                                    msg: "Note Copied Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );}
                                  else
                                    notesList[searchedNotesIndex.elementAt(index)] = newNote!;
            
            
                                String notes = UserPrefrences.encode(notesList);
                                await UserPrefrences.setNotes(notes);
                                
                                
                                searchedNotesList.clear();
                                
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: randColor(),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 30, 10, 30),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          searchedNotesList[index].title,
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontFamily: 'Flaunters',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        searchedNotesList[index].dateCreated,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 78, 80, 57),
                                          fontSize: 15,
                                          fontFamily: 'Flaunters',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ) : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
                        child: Center(
                          child: Text("No Results Found",
                          style : TextStyle(
                            fontSize: 20,
                            fontFamily: 'Flaunters',
                            color: Color.fromARGB(255, 127, 127, 127),
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNote()),
                );
                newNote = res;
                newNote == null ? null : notesList.add(newNote!);

                String notes = UserPrefrences.encode(notesList);
                await UserPrefrences.setNotes(notes);

                setState((){});
              },
              child: const Icon(
                Icons.add,
                size: 28,
              ),
              backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            ),
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
                          const Text(
                            "Notes",
                            style: TextStyle(
                              fontFamily: 'GresaRegular',
                              color: Colors.white,
                              fontSize: 45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              searchNote = !searchNote;
                              searchController.text = "";
                              isSearched = false;
                              setState(() {});
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 57, 57, 57),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: notesList.length,
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoteEdit(note: notesList[index])),
                              );
                              
                                noteDataList = res;
                                newNote = noteDataList[0];

                                if(noteDataList[1] == true){
                                  notesList.removeAt(index);
                                  Fluttertoast.showToast(
                                  msg: "Note Deleted Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                                }
                                else if(noteDataList[2] == true){
                                  notesList.add(newNote!);
                                  Fluttertoast.showToast(
                                  msg: "Note Copied Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );}
                                else
                                  notesList[index] = newNote!;


                              String notes = UserPrefrences.encode(notesList);
                              await UserPrefrences.setNotes(notes);
                              
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: randColor(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 30, 10, 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notesList[index].title,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontFamily: 'Flaunters',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      notesList[index].dateCreated,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 78, 80, 57),
                                        fontSize: 15,
                                        fontFamily: 'Flaunters',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Color randColor() {
    List<Color> colorsList = [
      const Color.fromARGB(255, 255, 171, 145),
      const Color.fromARGB(255, 255, 204, 128),
      const Color.fromARGB(255, 230, 238, 155),
      const Color.fromARGB(255, 128, 222, 234),
      const Color.fromARGB(255, 207, 147, 217),
      const Color.fromARGB(255, 244, 143, 177),
      const Color.fromARGB(255, 128, 203, 196),
    ];

    Random random = Random();
    int randomNumber = random.nextInt(7);

    return colorsList[randomNumber];
  }
}
