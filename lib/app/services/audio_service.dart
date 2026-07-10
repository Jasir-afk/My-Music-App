import 'dart:math';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';

enum RepeatMode { off, one, all }

class AudioService extends GetxController {
  static AudioService get to => Get.find<AudioService>();

  final AudioPlayer _audioPlayer = AudioPlayer();

  final Rxn<TrackModel> currentTrack = Rxn<TrackModel>();
  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxList<TrackModel> playlist = <TrackModel>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxDouble volume = 1.0.obs;

  // Repeat & Shuffle state
  final Rx<RepeatMode> repeatMode = RepeatMode.off.obs;
  final RxBool isShuffle = false.obs;

  void onInit() {
    super.onInit();

    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      print("Track completed, current repeat mode: ${repeatMode.value}");
      print(
        "Current index: ${currentIndex.value}, Playlist length: ${playlist.length}",
      );
      _onTrackComplete();
    });
  }

  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void _onTrackComplete() {
    print("_onTrackComplete called");
    switch (repeatMode.value) {
      case RepeatMode.one:
        print("RepeatMode.one - replaying current track");
        if (currentTrack.value != null) playTrack(currentTrack.value!);
        break;
      case RepeatMode.all:
        print("RepeatMode.all - advancing to next track");
        _advanceTrack();
        break;
      case RepeatMode.off:
        print("RepeatMode.off - checking if more tracks available");
        if (currentIndex.value < playlist.length - 1) {
          print("More tracks available, advancing");
          _advanceTrack();
        } else {
          print("No more tracks, stopping");
        }
        break;
    }
  }

  void _advanceTrack() {
    if (playlist.isEmpty) return;
    if (isShuffle.value) {
      final rand = Random();
      int next;
      do {
        next = rand.nextInt(playlist.length);
      } while (next == currentIndex.value && playlist.length > 1);
      currentIndex.value = next;
    } else {
      currentIndex.value = (currentIndex.value + 1) % playlist.length;
    }
    playTrack(playlist[currentIndex.value]);
  }

  /// Cycle through: off → one → all → off
  void toggleRepeat() {
    switch (repeatMode.value) {
      case RepeatMode.off:
        repeatMode.value = RepeatMode.one;
        break;
      case RepeatMode.one:
        repeatMode.value = RepeatMode.all;
        break;
      case RepeatMode.all:
        repeatMode.value = RepeatMode.off;
        break;
    }
  }

  void toggleShuffle() {
    isShuffle.value = !isShuffle.value;
  }

  void setPlaylist(List<TrackModel> tracks, int startIndex) {
    if (tracks.isEmpty) return;
    playlist.assignAll(tracks);
    currentIndex.value = startIndex;
    playTrack(tracks[startIndex]);
  }

  Future<void> playTrack(TrackModel track) async {
    try {
      currentTrack.value = track;
      isPlaying.value = false;
      position.value = Duration.zero;
      duration.value = Duration.zero;

      final String streamUrl =
          track.streamUrl ??
          'https://api.audius.co/v1/tracks/${track.id}/stream?app_name=my_music_app';

      print("Playing track: ${track.title} from URL: $streamUrl");

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(streamUrl));
      isPlaying.value = true;
    } catch (e) {
      print("Error playing audio: $e");
      Get.snackbar(
        'Playback Error',
        'Could not play the selected track.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (currentTrack.value == null) return;
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> seek(Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
  }

  void playNext() {
    if (playlist.isEmpty) return;
    _advanceTrack();
  }

  void playPrevious() {
    if (playlist.isEmpty) return;
    if (currentIndex.value > 0) {
      currentIndex.value--;
      playTrack(playlist[currentIndex.value]);
    } else {
      currentIndex.value = playlist.length - 1;
      playTrack(playlist[playlist.length - 1]);
    }
  }

  Future<void> setVolume(double value) async {
    volume.value = value;
    await _audioPlayer.setVolume(value);
  }
}
