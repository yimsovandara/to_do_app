import 'package:flutter/material.dart';
import 'widgets/task_card.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Complete project design',
      'description': 'Finalize UI mockups and design system',
      'dueDate': 'Jun 5, 2026',
      'priority': TaskPriority.high,
      'isCompleted': false,
    },
    {
      'title': 'Review code',
      'description': 'Review pull requests from team members',
      'dueDate': 'Jun 3, 2026',
      'priority': TaskPriority.medium,
      'isCompleted': false,
    },
    {
      'title': 'Update documentation',
      'dueDate': 'Jun 7, 2026',
      'priority': TaskPriority.low,
      'isCompleted': true,
    },
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
            title: task['title'],
            description: task['description'],
            dueDate: task['dueDate'],
            priority: task['priority'],
            isCompleted: task['isCompleted'],
            onToggleComplete: () {
              setState(() {
                tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
              });
            },
            onEdit: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Edit: ${task['title']}')));
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
