import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model/task_model.dart';

class TaskController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final tagsController = TextEditingController();

  final selectedPriority = TaskPriority.medium.obs;
  final selectedDueDate = Rxn<DateTime>();

  // Edit Mode variables
  final isEditing = false.obs;
  String? editingTaskId;
  DateTime? createdAt;
  bool isCompleted = false;

  @override
  void onInit() {
    super.onInit();
    final task = Get.arguments as TaskModel?;
    if (task != null) {
      isEditing.value = true;
      editingTaskId = task.id;
      createdAt = task.createdAt;
      isCompleted = task.isCompleted;

      titleController.text = task.title;
      descriptionController.text = task.description ?? '';
      categoryController.text = task.category ?? '';
      tagsController.text = task.tags.join(', ');
      selectedPriority.value = task.priority;
      selectedDueDate.value = task.dueDate;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    tagsController.dispose();
    super.onClose();
  }
}
