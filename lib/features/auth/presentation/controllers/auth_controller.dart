import 'dart:async';

import 'package:get/get.dart';
import 'package:mahder_mobile/core/utils/message.dart';
import 'package:mahder_mobile/features/auth/data/models/new_user.dart';
import 'package:mahder_mobile/features/auth/domain/entities/dialect_entity.dart';
import 'package:mahder_mobile/features/auth/domain/entities/language_entity.dart';
import 'package:mahder_mobile/features/auth/domain/usecases/base_data_usecase.dart';
import '../../../../../routes/app_routes.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthController extends GetxController {
  final AuthUseCase _authUseCase;
  final BaseDataUsecase _baseDataUseCase;

  AuthController(this._authUseCase,this._baseDataUseCase);


  ///Register
  RxBool isRegistering = false.obs;
  RxBool isTermsAccepted = false.obs;
  RxString registeredPhone = "".obs;
  RxString registeredPassword = "".obs;
  RxBool isActivatingAccount = false.obs;
  RxString registerLoadingReason = "".obs;
  RxnString verificationId = RxnString(null);

  ///Register Profile
  RxString firstName = ''.obs;
  RxString middleName = ''.obs;
  RxString lastName = ''.obs;
  RxString birthDate = ''.obs;
  RxnString gender = RxnString(null);
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxInt currentPage = 0.obs;
  RxBool isRegisteringProfile = false.obs;
  RxString registerProfileLoadingReason = "".obs;


  ///Language
  RxnString selectedLanguageId = RxnString(null);
  RxSet<LanguageEntity> languages = <LanguageEntity>{}.obs;
  RxBool isLoadingLanguages = false.obs;

  ///Dialects
  RxnString selectedDialectId = RxnString(null);
  RxSet<DialectEntity> dialects = <DialectEntity>{}.obs;
  RxBool isLoadingDialects = false.obs;

  ///Login
  RxBool isLoggingIn = false.obs;
  RxString loginLoadingReason = "".obs;
  RxString errorMessage = ''.obs;

  ///Forgot password
  RxInt forgotPasswordPage = 0.obs;
  RxBool isRequestingOtp = false.obs;
  Rx<String> forgotPhoneNumber = "".obs;
  RxBool isVerifyingOtp = false.obs;
  Rx<String> otp = "".obs;
  RxBool isResettingPassword = false.obs;
  RxString forgotLoadingReason = ''.obs;

  RxBool canResend = true.obs;
  RxInt countdown = 0.obs;

  Timer? _resendTimer;


  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> register(String phone , {isActivating = false}) async {
    if (!canResend.value) {
      showErrorMessage("Please wait for ${countdown.value} seconds before requesting again");
      return;
    }
    isRegistering.value = true;
    if(isActivating) {
      registerLoadingReason.value = "Requesting Code";
    } else {
      registerLoadingReason.value = "Registering";
    }
    String? id = await _authUseCase.register(phone);
    print(id);
    if(id != null) {
      registeredPhone.value = phone;
      verificationId.value = id;
      _startCountdownTimer();
    }
    isRegistering.value = false;
  }
  Future<void> activateAccount(String otp) async {
    isActivatingAccount.value = true;
    registerLoadingReason.value = "Activating account";
    final isSuccess = await _authUseCase.activateAccount(verificationId.value! , registeredPhone.value , otp);

    isActivatingAccount.value = false;
  }
  Future<void> registerProfile() async {
    NewUser newUser = NewUser(
        firstName: firstName.value,
        middleName: middleName.value,
        lastName: lastName.value,
        birthDate: birthDate.value,
        gender: gender.value!,
        languageId: selectedLanguageId.value!,
        dialectId: selectedDialectId.value!,
        email: email.value,
        password: password.value);
    isRegisteringProfile.value = true;
    registerProfileLoadingReason.value = "Registering Profile";
    await _authUseCase.registerProfile(newUser);
    isRegisteringProfile.value = false;
  }

  Future<void> login(String phone, String password) async {
    isLoggingIn.value = true;
    loginLoadingReason.value = "Logging in";
    try {
      await _authUseCase.login(phone, password);
    } finally {
      isLoggingIn.value = false;
    }
  }
  Future<void> requestOtp(String phone , {isActivatingAccount = false}) async {
    if (!canResend.value) {
      showErrorMessage("Please wait for ${countdown.value} seconds before requesting again");
      return;
    }
    isRequestingOtp.value = true;
    if(isActivatingAccount){
      registerLoadingReason.value = "Requesting Code";
    }
    else{
      forgotLoadingReason.value = "Requesting Code";
    }
    final isSuccess = await _authUseCase.requestOtp(phone);
    if(isSuccess){
      _startCountdownTimer();
      if(!isActivatingAccount) {
        forgotPhoneNumber.value = phone;
        forgotPasswordPage.value = 1;
      }
    }
    isRequestingOtp.value = false;
  }
  Future<void> verifyOtp(String code) async {
    isVerifyingOtp.value = true;
    forgotLoadingReason.value = "Verifying code";
    final isSuccess = await _authUseCase.verifyOtp(forgotPhoneNumber.value , code);
    if(isSuccess){
      otp.value = code;
      forgotPasswordPage.value = 2;
    }
    isVerifyingOtp.value = false;
  }
  Future<void> resetPassword(String newPassword) async {
    isResettingPassword.value = true;
    forgotLoadingReason.value = "Resetting Password";
    final isSuccess = await _authUseCase.resetPassword(forgotPhoneNumber.value , otp.value , newPassword);
    isResettingPassword.value = false;
    if(isSuccess){
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void _startCountdownTimer() {
    canResend.value = false;
    countdown.value = 120;

    _resendTimer?.cancel(); // Cancel previous if any
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;
      if (countdown.value <= 0) {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void saveFirstStage(String fName , String mName , String lName , String bDate , String genderValue) {
    firstName.value = fName;
    middleName.value = mName;
    lastName.value = lName;
    birthDate.value = bDate;
    gender.value = genderValue;
    currentPage.value = 1; // Move to the next page
  }
  Future<void> getLanguages() async {
    isLoadingLanguages.value = true;
    final result = await _baseDataUseCase.getLanguages();
    languages.value = Set.from(result);
    isLoadingLanguages.value = false;
  }
  Future<void> getDialects(String languageId) async {
    isLoadingDialects.value = true;
    final result = await _baseDataUseCase.getDialects(languageId);
    dialects.value = Set.from(result);
    isLoadingDialects.value = false;
  }
  void saveThirdStage(String languageId, String dialectId , String email) {
    selectedLanguageId.value = languageId;
    selectedDialectId.value = dialectId;
    this.email.value = email;
    currentPage.value = 3;
  }
}
