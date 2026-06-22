import 'package:get/get.dart';
import 'package:my_musics/app/services/auth_service.dart';

class InitialBinding extends Bindings {
  void dependencies() {
    Get.put(AuthService(), permanent: true);
  }
}
