import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/task_model/task_model.dart';

class TaskRepository extends GetxService {
  static const String _tableName = 'tasks';
  late Database _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_app.db');

    _db = await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
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

  /// Create a new task
  Future<void> createTask(TaskModel task) async {
    try {
      await _db.insert(_tableName, task.toJson());
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  /// Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final result = await _db.query(_tableName, orderBy: 'createdAt DESC');
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  /// Get task by ID
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final result = await _db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isEmpty) return null;
      return TaskModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  /// Get completed tasks
  Future<List<TaskModel>> getCompletedTasks() async {
    try {
      final result = await _db.query(
        _tableName,
        where: 'isCompleted = ?',
        whereArgs: [1],
        orderBy: 'updatedAt DESC',
      );
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching completed tasks: $e');
    }
  }

  /// Get active tasks
  Future<List<TaskModel>> getActiveTasks() async {
    try {
      final result = await _db.query(
        _tableName,
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'priority DESC, dueDate ASC',
      );
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching active tasks: $e');
    }
  }

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    try {
      final result = await _db.query(
        _tableName,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'createdAt DESC',
      );
      return result.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching tasks by category: $e');
    }
  }

  /// Update a task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _db.update(
        _tableName,
        task.copyWith(updatedAt: DateTime.now()).toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final task = await getTaskById(taskId);
      if (task != null) {
        await updateTask(
          task.copyWith(
            isCompleted: !task.isCompleted,
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      throw Exception('Error toggling task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await _db.delete(_tableName);
    } catch (e) {
      throw Exception('Error deleting all tasks: $e');
    }
  }

  /// Get task count
  Future<int> getTaskCount() async {
    try {
      final result = await _db.rawQuery('SELECT COUNT(*) FROM $_tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting task count: $e');
    }
  }

  /// Get completed task count
  Future<int> getCompletedTaskCount() async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) FROM $_tableName WHERE isCompleted = 1',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting completed task count: $e');
    }
  }

  /// Close database
  Future<void> closeDatabase() async {
    await _db.close();
  }
}
