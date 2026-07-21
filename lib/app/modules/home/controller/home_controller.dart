import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/data/models/task_model/task_model.dart';

import '../../../data/repositories/task_repository/task_repository.dart';

class HomeController extends GetxController {
  final TaskRepository repository;
  HomeController(this.repository);

  final tasks = <TaskModel>[].obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final fetchedTasks = await repository.getAllTasks();
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      debugPrint("Error fetching home tasks : ${e.toString()}");
      Get.snackbar(
        'Error',
        'Failed to load tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<TaskModel> get filteredTasks {
    if (selectedFilter.value == 'Active') {
      return tasks.where((t) => t.isCompleted == 0).toList();
    } else if (selectedFilter.value == 'Completed') {
      return tasks.where((t) => t.isCompleted == 1).toList();
    }
    return tasks;
  }

  Future<void> toggleTask(String id) async {
    try {
      await repository.toggleTaskCompletion(id);
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
