import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Note {
  int? id;
  String title;
  String content;
  String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  set color(int color) {}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, date TEXT)',
        );
      },
      version: 1,
    );

    return _database;
  }

  Future<void> save() async {
    final Database db = await database;
    await db.insert(
      'notes',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> getAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: maps[i]['date'],
      );
    });
  }

  Future<void> delete() async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update() async {
    final db = await database;
    await db.update(
      'notes',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
