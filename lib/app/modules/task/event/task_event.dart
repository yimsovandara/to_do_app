import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/data/model/task_model/task_model.dart';
import 'package:to_do_app/app/data/repositories/task_repository.dart';
import '../controllers/task_controller.dart';

class TaskEvent {
  final _repository = Get.find<TaskRepository>();
  final _controller = Get.find<TaskController>();

  Future<void> pickDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      _controller.selectedDueDate.value = pickedDate;
    }
  }

  Future<void> createTask() async {
    if (_controller.formKey.currentState == null || !_controller.formKey.currentState!.validate()) {
      return;
    }

    try {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.createTask(task);
      Get.back();
      Get.snackbar(
        'Success',
        'Task created successfully!',
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
