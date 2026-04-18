import 'package:get/get.dart';
import '../../domain/usecases/auth_usecase.dart';

class SplashScreenController extends GetxController {
  final AuthUseCase _authUseCase;

  SplashScreenController(this._authUseCase);

  Future<void> checkAuthStatus() async {
      await _authUseCase.checkToken();
  }
}
