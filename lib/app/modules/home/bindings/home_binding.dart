import 'package:get/get.dart';
import 'package:to_do_app/app/modules/home/controller/home_controller.dart';

import '../../../data/repositories/task_repository/task_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<TaskRepository>()),
    );
  }
}
