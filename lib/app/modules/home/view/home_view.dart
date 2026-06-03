import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/modules/task/views/widgets/task_card.dart';

import 'widget/card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'TODO',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TaskStatsCard(
                    title: 'Tasks',
                    quantity: 12,
                    icon: Icons.checklist,
                    iconColor: Colors.blue,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TaskStatsCard(
                    title: 'Completed',
                    quantity: 8,
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'All Tasks',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildFilterButton('All'),
                SizedBox(width: 12),
                _buildFilterButton('Active'),
                SizedBox(width: 12),
                _buildFilterButton('Completed'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return TaskCard(
                    title: 'Task ${index + 1}',
                    description: 'Description for task ${index + 1}',
                    dueDate: 'Due in ${index + 1} days',
                    priority: TaskPriority.values[index % 3],
                    isCompleted: index % 2 == 0,
                    onToggleComplete: () {
                      // Handle toggle complete
                    },
                    onEdit: () {
                      // Handle edit
                    },
                    onDelete: () {
                      // Handle delete
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.toNamed('/create-task');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,

            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
