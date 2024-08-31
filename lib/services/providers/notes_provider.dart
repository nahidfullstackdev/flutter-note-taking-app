import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:students_note_app/services/models/notes_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final noteDb = await sql.openDatabase(
    path.join(dbPath, 'Studentnote.db'),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE user_notes(id TEXT PRIMARY KEY, image TEXT, title TEXT, note TEXT, folderId TEXT )');
    },
    version: 2,
  );
  return noteDb;
}

class UserNotesNotifier extends StateNotifier<List<NotesModel>> {
  UserNotesNotifier() : super(const []);

  Future<void> loadNotes() async {
    final db = await _getDatabase();

    final data = await db.query('user_notes');

    final notes = data.map((row) => NotesModel.fromMap(row)).toList();

    state = notes;
  }

  Future<void> updateNote(NotesModel note) async {
    final db = await _getDatabase();

    await db.update('user_notes', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);

    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    final db = await _getDatabase();
    await db.delete('user_notes', where: 'id = ?', whereArgs: [id]);
    await loadNotes();
  }

  void addNote(File image, String title, String note, ) async {
    //image part
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    //.....................................//

    final newNote = NotesModel(
      image: copiedImage,
      title: title,
      note: note,
 
    );
    //............................................//
    // storing data in sql Database..
    final db = await _getDatabase();

    db.insert(
      'user_notes',
      newNote.toMap(),
    );
    //.............................................//
    state = [
      newNote,
      ...state
    ]; // '...' is spread operator to include old state list that shouldn't lose them.
  }
}

//.. setup the riverpod provider...

final userNoteprovider =
    StateNotifierProvider<UserNotesNotifier, List<NotesModel>>(
  (ref) => UserNotesNotifier(),
);
