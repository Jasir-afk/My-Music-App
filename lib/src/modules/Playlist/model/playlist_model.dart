import 'package:my_musics/src/modules/homescreen/model/track_model.dart';

class PlaylistModel {
  final String id;
  final String name;
  final List<TrackModel> songs;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.songs,
  });
}
