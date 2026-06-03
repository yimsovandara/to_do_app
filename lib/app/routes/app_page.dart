import 'package:get/get.dart';
import 'package:to_do_app/app/modules/home/bindings/home_binding.dart';
import 'package:to_do_app/app/modules/home/view/home_view.dart';
import 'package:to_do_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:to_do_app/app/modules/splash/view/splash_view.dart';
import 'package:to_do_app/app/modules/task/bindings/task_binding.dart';
import 'package:to_do_app/app/modules/task/views/create_task_view.dart';
import 'package:to_do_app/app/routes/app_routes.dart';

class AppPage {
  static const initial = AppRoutes.splash;
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.createTask,
      page: () => const CreateTaskView(),
      binding: TaskBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
