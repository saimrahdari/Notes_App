import 'package:notes_app/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPrefrences {
  static SharedPreferences? _preferences;

  static const _keyNotes = 'notes';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setNotes(String notes) async =>
      await _preferences!.setString(_keyNotes, notes);

  static String? getNotes() => _preferences!.getString(_keyNotes);

  static String encode(List<Note> notes) => json.encode(
        notes
            .map<Map<String, dynamic>>((note) => Note.toMap(note))
            .toList(),
      );

    static List<Note> decode(String notes) =>
      (json.decode(notes) as List<dynamic>)
          .map<Note>((item) => Note.fromJson(item))
          .toList();

}