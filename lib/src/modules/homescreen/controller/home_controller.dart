import 'package:get/get.dart';
import 'package:my_musics/src/modules/homescreen/model/song_modle.dart';
import 'package:my_musics/src/modules/homescreen/repo/home_repo.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  RxList<SongModel> songList = <SongModel>[].obs;
  RxBool isLoading = false.obs;

  void onInit() {
    super.onInit();
    getSongs();
  }

  Future<void> getSongs() async {
    try {
      isLoading.value = true;

      final songs = await _repository.getSongs();

      songList.assignAll(songs);

      print("Songs Loaded: ${songList.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
