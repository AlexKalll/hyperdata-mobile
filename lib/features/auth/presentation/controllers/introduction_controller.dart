import 'package:get/get.dart';
import 'package:leyu_mobile/core/services/onboarding_service.dart';
import 'package:leyu_mobile/routes/app_routes.dart';

class IntroductionController extends GetxController {
  RxInt pageIndex = 0.obs;

  void next({isSwiped = false}) {
    if (pageIndex.value == 2 && isSwiped) {
      return;
    }
    if (pageIndex.value == 2) {
      // Mark introduction as seen before navigating away
      OnboardingService.markIntroductionAsSeen();
      Get.offAndToNamed(AppRoutes.register);
      return;
    }
    pageIndex.value++;
  }

  void previous() {
    if (pageIndex.value > 0) {
      pageIndex.value--;
    }
  }
}
