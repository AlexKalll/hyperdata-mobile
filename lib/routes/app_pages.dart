import 'package:get/get.dart';
import 'package:leyu_mobile/features/auth/presentation/pages/activate_account_page.dart';
import 'package:leyu_mobile/features/auth/presentation/pages/introduction_page.dart';
import 'package:leyu_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:leyu_mobile/features/auth/presentation/pages/register_profile_page.dart';
import 'package:leyu_mobile/features/home/presentation/bindings/home_binding.dart';
import 'package:leyu_mobile/features/home/presentation/pages/task_instruction_page.dart';
import 'package:leyu_mobile/features/home/presentation/pages/task_submission_page.dart';
import 'package:leyu_mobile/features/profile/presentation/bindings/profile_binding.dart';
import 'package:leyu_mobile/features/profile/presentation/pages/main_profile_screen.dart';
import 'package:leyu_mobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:leyu_mobile/features/profile/presentation/pages/change_password_page.dart';
import 'package:leyu_mobile/features/notification/presentation/bindings/notification_binding.dart';
import 'package:leyu_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:leyu_mobile/routes/app_routes.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_screen_page.dart';
import '../features/home/domain/entities/task_type_enum.dart';
import '../features/home/presentation/pages/home_page.dart';

class AppPages {
  static const initial = AppRoutes.splashScreen;

  static final routes = [
    /// Shared
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreenPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.introduction,
      page: () => IntroductionPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordPage(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.activateAccount,
      page: () => const ActivateAccountPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.registerProfile,
      page: () => RegisterProfilePage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.taskInstructionPage,
      page: () => const TaskInstructionPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.taskSubmissionPage,
      page: () {
        Map<String, Object> arguments = Get.arguments as Map<String, Object>;
        String taskName = arguments['taskName'] as String;
        TaskType taskType = arguments['taskType'] as TaskType;
        return TaskSubmissionPage(taskName: taskName, taskType: taskType);
      },
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profilePage,
      page: () => const MainProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationPage(),
      binding: NotificationBinding(),
    ),
  ];
}
