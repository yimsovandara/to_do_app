import 'package:flutter/material.dart';
import '../../../data/models/task_model/task_model.dart';
import 'widgets/task_card.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final List<TaskModel> tasks = [
    TaskModel(
      id: '1',
      title: 'Complete project design',
      description: 'Finalize UI mockups and design system',
      dueDate: DateTime(2026, 6, 5),
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    TaskModel(
      id: '2',
      title: 'Review code',
      description: 'Review pull requests from team members',
      dueDate: DateTime(2026, 6, 3),
      priority: TaskPriority.medium,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    TaskModel(
      id: '3',
      title: 'Update documentation',
      dueDate: DateTime(2026, 6, 7),
      priority: TaskPriority.low,
      isCompleted: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks'), centerTitle: false),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onToggleComplete: () {
              setState(() {
                tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
              });
            },
            onEdit: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Edit: ${task.title}')));
            },
            onDelete: () {
              setState(() {
                tasks.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add new task')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
