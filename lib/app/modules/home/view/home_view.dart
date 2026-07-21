import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/modules/task/views/widgets/task_card.dart';
import '../controller/home_controller.dart';
import 'widget/card.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.find<HomeController>();

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
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: TaskStatsCard(
                      title: 'Tasks',
                      quantity: controller.tasks.length,
                      icon: Icons.checklist,
                      iconColor: Colors.blue,
                      onTap: () {
                        controller.selectedFilter.value = 'All';
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TaskStatsCard(
                      title: 'Completed',
                      quantity: controller.tasks
                          .where((t) =>  t.isCompleted == 1)
                          .length,
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      onTap: () {
                        controller.selectedFilter.value = 'Completed';
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Text(
                  'All Tasks',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  _buildFilterButton('All'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Active'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Completed'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final tasksToDisplay = controller.filteredTasks;

                if (tasksToDisplay.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasksToDisplay.length,
                  itemBuilder: (context, index) {
                    final task = tasksToDisplay[index];
                    return TaskCard(
                      task: task,
                      onToggleComplete: () {
                        controller.toggleTask(task.id);
                      },
                      onEdit: () {
                        Get.toNamed('/create-task', arguments: task);
                      },
                      onDelete: () {
                        controller.deleteTask(task.id);
                      },
                    );
                  },
                );
              }),
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
    final isSelected = controller.selectedFilter.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedFilter.value = label;
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
