import 'package:get/get.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';

class InitialBinding extends Bindings {


  void dependencies() {
    Get.put(AudioService(), permanent: true);
    Get.put(PlaylistController(), permanent: true);
  }
}
