import 'package:get/get.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/app/services/notification_service.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';

class InitialBinding extends Bindings {
  void dependencies() {
    Get.put(PlaybackService(), permanent: true);
    Get.put(PlaylistController(), permanent: true);
    Get.put(NotificationService(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
