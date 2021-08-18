class Note{

  String title;
  String text;
  String dateCreated;

  Note({required this.title, required this.text, required this.dateCreated});

  factory Note.fromJson(Map<String, dynamic> jsonData) {
    return Note(
      title: jsonData['title'],
      text: jsonData['text'],
      dateCreated: jsonData['dateCreated']
    );
  }

  static Map<String, dynamic> toMap(Note note) => {
        'title': note.title,
        'text': note.text,
        'dateCreated': note.dateCreated
      };
}