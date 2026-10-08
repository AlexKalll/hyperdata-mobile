import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mahder_mobile/core/services/audio_manager_service.dart';
import 'package:mahder_mobile/core/services/onesignal_service.dart';
import 'package:mahder_mobile/features/home/data/models/task_submission_model.dart';
import 'package:mahder_mobile/features/home/data/services/file_storage_service.dart';
import 'package:mahder_mobile/features/home/data/services/task_storage_service.dart';
import 'package:mahder_mobile/routes/app_pages.dart';
import 'core/cache/cache_manager.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/localization_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Hive
  try {
    await Hive.initFlutter();

    // Register TaskSubmissionModel adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskSubmissionModelAdapter());
    }

    print('Hive initialized successfully');

    // Perform cleanup routine after Hive initialization
    await _performStartupCleanup();
  } catch (e) {
    print('Error initializing Hive: $e');
    print('App will continue with in-memory storage only');
  }

  await CacheManager.init();

  // Initialize date formatting for all supported locales
  await initializeDateFormatting();

  // Initialize LocalizationController
  final localizationController = LocalizationController();
  await localizationController.init();
  Get.put(localizationController);

  // Initialize AudioManagerService
  Get.put(AudioManagerService());

  // Initialize OneSignal
  await OneSignalService.initialize();

  runApp(const MyApp());
}

/// Performs cleanup routine on app startup
/// Removes orphaned files and invalid database entries
Future<void> _performStartupCleanup() async {
  if (kIsWeb) {
    print('Skipping native file cleanup on web');
    return;
  }

  try {
    print('Starting app startup cleanup...');

    // Initialize storage services for cleanup
    final fileStorageService = FileStorageService();
    final taskStorageService = TaskStorageService();

    // Initialize task storage service
    await taskStorageService.init();

    // Get all valid task IDs from Hive
    final validTaskIds = await taskStorageService.getAllTaskIds();
    print('Found ${validTaskIds.length} tasks in database');

    // Clean up orphaned files (files without database entries)
    await fileStorageService.cleanupOrphanedFiles(validTaskIds);

    // Clean up invalid entries (database entries with missing files)
    await taskStorageService.cleanupInvalidEntries(fileStorageService);

    print('App startup cleanup completed successfully');
  } catch (e) {
    // Don't block app startup if cleanup fails
    print('Error during startup cleanup: $e');
    print('App will continue normally');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mahder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'openSans', useMaterial3: false),
      // Localization configuration
      translations: AppTranslations(),
      locale: Get.find<LocalizationController>().locale,
      fallbackLocale: const Locale('en', 'US'),

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
