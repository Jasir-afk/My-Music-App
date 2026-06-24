import 'package:my_musics/src/modules/homescreen/model/song_modle.dart';

class HomeRepository {
  /// Get all songs
  Future<List<SongModel>> getSongs() async {
    // Firebase service removed - implement alternative data source
    return [];
  }

  /// Get trending songs
  Future<List<SongModel>> getTrendingSongs() async {
    // Firebase service removed - implement alternative data source
    return [];
  }
}
