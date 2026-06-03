import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/task_model/task_model.dart';

class TaskController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final tagsController = TextEditingController();

  final selectedPriority = TaskPriority.medium.obs;
  final selectedDueDate = Rxn<DateTime>();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    tagsController.dispose();
    super.onClose();
  }
}
