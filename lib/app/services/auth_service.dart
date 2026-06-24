import 'package:get/get.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  void login() {
    _isLoggedIn.value = true;
  }

  void logout() {
    _isLoggedIn.value = false;
  }
}
