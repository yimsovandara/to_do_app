import 'package:sqflite/sqflite.dart';
import '../../database/app_data_base.dart';
import '../../models/task_model/task_model.dart';

class TaskRepository {
  final DatabaseService databaseService;
  TaskRepository(this.databaseService);

  Database get _db => databaseService.db;

  List<TaskModel> _mapTasks(List<Map<String, Object?>> result) {
    return result.map(TaskModel.fromJson).toList();
  }

  /// Create a new task
  Future<void> createTask(TaskModel task) async {
    try {
      await _db.insert(
        DatabaseService.tableName,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  /// Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final result = await _db.query(
        DatabaseService.tableName,
        orderBy: 'createdAt DESC',
      );

      return _mapTasks(result);
    } catch (e) {
      throw Exception('Error fetching all tasks: $e');
    }
  }

  /// Get task by ID
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final result = await _db.query(
        DatabaseService.tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isEmpty) return null;
      return TaskModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Error fetching get all task: $e');
    }
  }

  /// Get completed tasks
  Future<List<TaskModel>> getCompletedTasks() async {
    try {
      final result = await _db.query(
        DatabaseService.tableName,
        where: 'isCompleted = ?',
        whereArgs: [1],
        orderBy: 'updatedAt DESC',
      );
      return _mapTasks(result);
    } catch (e) {
      throw Exception('Error fetching completed tasks: $e');
    }
  }

  /// Get active tasks
  Future<List<TaskModel>> getActiveTasks() async {
    try {
      final result = await _db.query(
        DatabaseService.tableName,
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'priority DESC, dueDate ASC',
      );
      return _mapTasks(result);
    } catch (e) {
      throw Exception('Error fetching active tasks: $e');
    }
  }

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    try {
      final result = await _db.query(
        DatabaseService.tableName,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'createdAt DESC',
      );
      return _mapTasks(result);
    } catch (e) {
      throw Exception('Error fetching tasks by category: $e');
    }
  }

  /// Update a task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _db.update(
        DatabaseService.tableName,
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
        await _db.rawUpdate(
          '''
  UPDATE tasks
  SET isCompleted = CASE
      WHEN isCompleted = 1 THEN 0
      ELSE 1
  END,
  updatedAt = ?
  WHERE id = ?
  ''',
          [DateTime.now().toIso8601String(), taskId],
        );
      }
    } catch (e) {
      throw Exception('Error toggling task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _db.delete(
        DatabaseService.tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await _db.delete(DatabaseService.tableName);
    } catch (e) {
      throw Exception('Error deleting all tasks: $e');
    }
  }

  /// Get task count
  Future<int> getTaskCount() async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseService.tableName}',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting task count: $e');
    }
  }

  /// Get completed task count
  Future<int> getCompletedTaskCount() async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseService.tableName} WHERE isCompleted = 1',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting completed task count: $e');
    }
  }

  /// Close databases
  Future<void> closeDatabase() async {
    await _db.close();
  }
}
