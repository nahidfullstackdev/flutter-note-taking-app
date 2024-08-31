import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:students_note_app/services/models/notes_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await sql.getDatabasesPath();
    final noteDb = await sql.openDatabase(
      path.join(dbPath, 'st_notes.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE st_notes(id TEXT PRIMARY KEY, image TEXT, title TEXT, note TEXT )');
      },
      version: 1,
    );
    return noteDb;
  }

  Future<void> insertNote(File image, String title, String note) async {
    //image part
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    //.....................................//
    final newNote =
        NotesModel(image: copiedImage, title: title, note: note, id: '');
    //............................................//
    // storing data in sql Database..
    final db = await instance.database;

    db.insert('st_notes', {
      'id': newNote.id,
      'image': newNote.image.path,
      'title': newNote.title,
      'note': newNote.note,
    });
  }

///////////////////////////////////////////////////
  Future<List<NotesModel>> getNotes() async {
    final db = await instance.database;

    final data = await db.query('st_notes');

    final notes = data
        .map(
          (json) => NotesModel.fromMap(json),
        )
        .toList();

    return notes;
  }

  Future<void> updateNote(NotesModel note) async {
    final db = await instance.database;
    await db.update(
      'st_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    await db.delete(
      'st_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();

//   static Database? _database;

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('notes.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE notes(id TEXT PRIMARY KEY, image TEXT, title TEXT, note TEXT');
//   }

//   Future<void> insertNote(NotesModel note) async {
//     final db = await instance.database;
//     await db.insert('notes', note.toMap());
//   }

//   Future<List<NotesModel>> getNotes() async {
//     final db = await instance.database;
//     final result = await db.query('notes');
//     return result.map((json) => NotesModel.fromMap(json)).toList();
//   }

  // Future<void> updateNote(NotesModel note) async {
  //   final db = await instance.database;
  //   await db.update(
  //     'notes',
  //     note.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  // Future<void> deleteNote(int id) async {
  //   final db = await instance.database;
  //   await db.delete(
  //     'notes',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
// }
