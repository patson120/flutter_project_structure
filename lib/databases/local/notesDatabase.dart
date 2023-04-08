import 'package:project_structure/databases/local/models/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = p.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    final idType = "INTERGER PRIMARY KEY AUTOINCREMENT";
    final booleanType = "BOOLEAN NOT NULL";
    final integerType = "INTEGER NOT NULL";
    final textType = "TEXT NOT NULL";

    // Méthode a duplpiquer pour créer autant de la table que souhaité
    await db.execute("""
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $booleanType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType,

    )
    """);
  }

  // Implémentation du CRUD

  Future<Note> create(Note note) async {
    final db = await instance.database;

/**
 * Autre façon de faire une insertion en base de données
 */
    /* final json = note.toMap();
    final columns =
        "${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}";

    final values =
        "${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}";
    final id =
        db.rawInsert("INSERT INTO $tableNotes ($columns) VALUES ($values)");
    */

    final id = await db.insert(tableNotes, note.toMap());

    return note.copy(id: id);
  }

  Future<Note?> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: "${NoteFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = "${NoteFields.time} ASC";

    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toMap());
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
