import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/widgets/language_changer.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';
import 'package:leyu_mobile/core/widgets/refresher.dart';
import 'package:leyu_mobile/features/home/data/models/task.dart';
import 'package:leyu_mobile/features/home/presentation/controllers/home_controller.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/profile_picture_widget.dart';
import 'package:leyu_mobile/features/home/presentation/widgets/wallet_widget.dart';
import 'package:leyu_mobile/routes/app_routes.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../core/widgets/image.dart';
import '../widgets/horizontal_carousel_widget.dart';
import '../widgets/task_card_widget.dart';
import '../widgets/task_filter_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find<HomeController>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    print('ScrollController listener added');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeController.getUserProfile();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9 &&
        !_homeController.isTasksLoading.value &&
        !_homeController.isLoadingMoreTasks.value &&
        _homeController.hasMoreTasks.value) {
      print("Fetching more recent tasks...");
      _homeController.fetchTasks(nextPage: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    debugPrint('HomePage: ScrollController disposed');
    super.dispose();
  }

  TaskFilter _getTaskFilterFromString(String filter) {
    switch (filter) {
      case 'recent':
        return TaskFilter.recent;
      case 'new':
        return TaskFilter.newTask;
      case 'completed':
        return TaskFilter.completed;
      default:
        return TaskFilter.all;
    }
  }

  String _getStringFromTaskFilter(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.recent:
        return 'recent';
      case TaskFilter.newTask:
        return 'new';
      case TaskFilter.completed:
        return 'completed';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: RefresherWidget(
          onRefresh: () {
            _homeController.fetchUserBalance();
            _homeController.fetchTasks();
            _homeController.refreshNotificationCount();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text('home.greeting'.trParams({'name': _homeController.userFirstName.value.capitalizeFirst ?? ''}),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                            overflow: TextOverflow.ellipsis,
                          )),
                          Text('home.welcome_message'.tr, style: const TextStyle(fontSize: 13 ,color: AppColors.grayText)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const LanguageChanger(isShortForm: true),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            await Get.toNamed(AppRoutes.notification);
                            _homeController.refreshNotificationCount();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              assetSvgImageWidget("notification.svg", width: 34, height: 34,color: const Color(0xFF364957)),
                              Obx(() {
                                final count = _homeController.notificationCount.value;
                                if (count == 0) return const SizedBox.shrink();
                                return Positioned(
                                  right: count > 9 ? -3 : 0,
                                  top: count > 9 ? -3 : 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF0000),
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 15,
                                      minHeight: 15,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count > 99 ? '99+' : count.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: (){
                            Get.toNamed(AppRoutes.profilePage);
                          },
                          child: Obx(()=>ProfilePictureWidget(
                            profilePictureUrl: _homeController.userProfilePic.value,
                            firstName: _homeController.userFirstName.value.isEmpty
                                ? null
                                : _homeController.userFirstName.value.capitalizeFirst,
                            lastName: _homeController.userMiddleName.value.isEmpty
                                ? null
                                : _homeController.userMiddleName.value.capitalizeFirst,
                          )),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: getScreenHeight(context)*0.02),
                WalletWidget(),
                SizedBox(height: getScreenHeight(context)*0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('home.tasks.your_tasks'.tr, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700,color: AppColors.darkGray)),
                    InkWell(
                      onTap: (){
                        _homeController.fetchUserBalance();
                        _homeController.fetchTasks();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            const Icon(Icons.replay_circle_filled_rounded, size: 18, color: AppColors.primary,),
                            const SizedBox(width: 2),
                            Text('home.tasks.refresh'.tr, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600,decoration: TextDecoration.underline),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: getScreenHeight(context)*0.015),
                Obx(() => TaskFilterTabs(
                  selectedFilter: _getTaskFilterFromString(_homeController.currentFilter.value),
                  onFilterChanged: (filter) {
                    _homeController.changeTaskFilter(_getStringFromTaskFilter(filter));
                  },
                )),
                SizedBox(height: getScreenHeight(context)*0.015),
                Expanded(
                  child: Obx(() {
                    final tasks = _homeController.tasks;
                    final isLoadingInitial = _homeController.isTasksLoading.value;
                    final isLoadingMore = _homeController.isLoadingMoreTasks.value;
                    final hasMore = _homeController.hasMoreTasks.value;
                    return isLoadingInitial
                        ? const Center(
                        child: LoadingWidget(isTransparent: true,))
                        : tasks.isEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: getScreenHeight(context)*0.05),
                          child: Center(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              assetSvgImageWidget("no-task.svg" , height: getScreenHeight(context)*0.25),
                              SizedBox(height: getScreenHeight(context)*0.02),
                              Text('home.tasks.empty'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          )),
                        )
                        : ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: tasks.length + (isLoadingMore || hasMore ? 1 : 0), // +1 for header, +1 for loader
                      itemBuilder: (context, index) {
                        final taskIndex = index;
                        if (taskIndex >= tasks.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: LoadingWidget(isTransparent: true),
                            ),
                          );
                        }

                        final task = tasks[taskIndex];
                        return TaskCardWidget(
                          task: task,
                          isRecent: task.doneCount > 0,
                          isCompleted: task.doneCount == task.totalCount,
                        );
                      },
                    );
                  }
            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
