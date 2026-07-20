import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/app_data_base.dart';
import '../../models/task_model/task_model.dart';

class TaskRepository extends GetxService {
  late final Database _db;

  List<TaskModel> _mapTasks(List<Map<String, Object?>> result) {
    return result.map(TaskModel.fromJson).toList();
  }

  Future<void> init() async {
    _db = await initDatabase();
  }

  /// Create a new task
  Future<void> createTask(TaskModel task) async {
    try {
      await _db.insert(tableName, task.toJson());
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  /// Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final result = await _db.query(tableName, orderBy: 'createdAt DESC');

      return _mapTasks(result);
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  /// Get task by ID
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final result = await _db.query(
        tableName,
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
        tableName,
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
        tableName,
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
        tableName,
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
        tableName,
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
      await _db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await _db.delete(tableName);
    } catch (e) {
      throw Exception('Error deleting all tasks: $e');
    }
  }

  /// Get task count
  Future<int> getTaskCount() async {
    try {
      final result = await _db.rawQuery('SELECT COUNT(*) FROM $tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting task count: $e');
    }
  }

  /// Get completed task count
  Future<int> getCompletedTaskCount() async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE isCompleted = 1',
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
