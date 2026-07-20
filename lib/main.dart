import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/routes/app_page.dart';

import 'package:to_do_app/app/data/repositories/task_repository/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final taskRepo = TaskRepository();
  await taskRepo.init();
  Get.put<TaskRepository>(taskRepo, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.full,
      initialRoute: AppPage.initial,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      title: 'TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      getPages: AppPage.pages,
    );
  }
}
