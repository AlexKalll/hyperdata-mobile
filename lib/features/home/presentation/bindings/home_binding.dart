import 'package:get/get.dart';
import 'package:mahder_mobile/features/home/data/datasources/task_remote_data_source.dart';
import 'package:mahder_mobile/features/home/data/services/file_storage_service.dart';
import 'package:mahder_mobile/features/home/data/services/task_storage_service.dart';
import 'package:mahder_mobile/features/home/domain/repositories/task_repository.dart';
import 'package:mahder_mobile/features/home/domain/usecases/task_usecase.dart';
import 'package:mahder_mobile/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:mahder_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:mahder_mobile/features/notification/domain/usecases/notification_usecase.dart';
import 'package:mahder_mobile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mahder_mobile/features/profile/data/repositories/profile_repository.dart';
import 'package:mahder_mobile/features/profile/domain/usecases/profile_usecase.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/cache/local_storage.dart';
import '../controllers/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => TaskRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => TaskRepository(Get.find<TaskRemoteDataSource>()));
    Get.lazyPut(() => TaskUsecase(Get.find<TaskRepository>()));

    // Register notification dependencies
    Get.lazyPut(() => NotificationRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => NotificationRepository(Get.find<NotificationRemoteDataSource>()));
    Get.lazyPut(() => NotificationUsecase(Get.find<NotificationRepository>()));

    // Register profile dependencies
    Get.lazyPut(() => ProfileRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()));
    Get.lazyPut(() => ProfileUseCase(Get.find<ProfileRepositoryImpl>()));

    // Register storage services
    Get.lazyPut(() => LocalStorage());
    Get.lazyPut(() => FileStorageService());
    Get.lazyPut(() => TaskStorageService());

    // Register HomeController with storage services and notification usecase
    Get.lazyPut(() => HomeController(
      Get.find<LocalStorage>(),
      Get.find<TaskUsecase>(),
      Get.find<TaskStorageService>(),
      Get.find<FileStorageService>(),
      Get.find<NotificationUsecase>(),
      Get.find<ProfileUseCase>(),
    ));
  }
}
