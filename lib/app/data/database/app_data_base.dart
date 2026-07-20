import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = 'tasks';
late Database db;

Future<Database> initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'todo_app.db');

  return await openDatabase(path, version: 1, onCreate: _createTable);
}

Future<void> _createTable(Database db, int version) async {
  await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT,
        priority TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        category TEXT,
        tags TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
}
