import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/data/models/task_model/task_model.dart';
import 'package:to_do_app/app/data/repositories/task_repository/task_repository.dart';
import '../../home/controller/home_controller.dart';
import '../controllers/task_controller.dart';

class TaskEvent {
  final _repository = Get.find<TaskRepository>();
  final _controller = Get.find<TaskController>();

  Future<void> pickDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      _controller.selectedDueDate.value = pickedDate;
    }
  }

  Future<void> saveTask() async {
    if (_controller.formKey.currentState == null || !_controller.formKey.currentState!.validate()) {
      return;
    }

    try {
      final isEdit = _controller.isEditing.value;
      final task = TaskModel(
        id: isEdit ? _controller.editingTaskId! : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.titleController.text.trim(),
        description: _controller.descriptionController.text.trim().isEmpty
            ? null
            : _controller.descriptionController.text.trim(),
        dueDate: _controller.selectedDueDate.value,
        priority: _controller.selectedPriority.value,
        category: _controller.categoryController.text.trim().isEmpty
            ? null
            : _controller.categoryController.text.trim(),
        tags: _controller.tagsController.text.trim().isEmpty
            ? []
            : _controller.tagsController.text.split(',').map((tag) => tag.trim()).toList(),
        createdAt: isEdit ? _controller.createdAt ?? DateTime.now() : DateTime.now(),
        updatedAt: DateTime.now(),
        isCompleted: isEdit ? (_controller.isCompleted ? 1 : 0) : 0,
      );

      if (isEdit) {
        await _repository.updateTask(task);
      } else {
        await _repository.createTask(task);
      }

      // Refresh HomeController tasks if registered
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadTasks();
      }

      Get.back();
      Get.snackbar(
        'Success',
        isEdit ? 'Task updated successfully!' : 'Task created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}
