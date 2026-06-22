class SongModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final int playCount;
  final bool isTrending;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    required this.playCount,
    required this.isTrending,
  });

  /// Firestore -> SongModel
  factory SongModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SongModel(
      id: documentId,
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      album: map['album'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
      playCount: map['playCount'] ?? 0,
      isTrending: map['isTrending'] ?? false,
    );
  }

  /// SongModel -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'playCount': playCount,
      'isTrending': isTrending,
    };
  }
}
