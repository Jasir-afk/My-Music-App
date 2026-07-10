class TrackModel {
  final String? id;
  final String? title;
  final String? artwork;
  final String? artist;
  final String? artistId;
  final String? artistImage;
  final String? genre;
  final int? duration;
  final String? streamUrl;
  final int? playCount;
  final int? favoriteCount;
  final DateTime? createdAt;
  // Artist-level stats from the user object
  final int? artistTrackCount;
  final int? artistFollowerCount;

  TrackModel({
    this.id,
    this.title,
    this.artwork,
    this.artist,
    this.artistId,
    this.artistImage,
    this.genre,
    this.duration,
    this.streamUrl,
    this.playCount,
    this.favoriteCount,
    this.createdAt,
    this.artistTrackCount,
    this.artistFollowerCount,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    // Artwork can be an object with size keys or a direct string URL
    String? artworkUrl;
    final artwork = json['artwork'];
    if (artwork is Map) {
      artworkUrl = artwork['1000x1000']?.toString() ??
          artwork['480x480']?.toString() ??
          artwork['150x150']?.toString();
    } else {
      artworkUrl = artwork?.toString();
    }

    // Artist profile picture is also a nested object
    String? artistImageUrl;
    final profilePic = json['user']?['profile_picture'];
    if (profilePic is Map) {
      artistImageUrl = profilePic['480x480']?.toString() ??
          profilePic['1000x1000']?.toString() ??
          profilePic['150x150']?.toString();
    }

    // Stream URL is in stream.url, not stream_url
    String? streamUrl;
    final stream = json['stream'];
    if (stream is Map) {
      streamUrl = stream['url']?.toString();
    } else {
      streamUrl = json['stream_url']?.toString();
    }

    // Artist track and follower counts from user object
    final int? artistTrackCount =
        json['user']?['track_count'] as int?;
    final int? artistFollowerCount =
        json['user']?['follower_count'] as int?;

    return TrackModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      artwork: artworkUrl,
      artist: json['artist']?.toString() ?? json['user']?['name']?.toString(),
      artistId:
          json['artist_id']?.toString() ?? json['user']?['id']?.toString(),
      artistImage: artistImageUrl,
      genre: json['genre']?.toString(),
      duration: json['duration'] as int?,
      streamUrl: streamUrl,
      playCount: json['play_count'] as int?,
      favoriteCount: json['favorite_count'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      artistTrackCount: artistTrackCount,
      artistFollowerCount: artistFollowerCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artwork': artwork,
      'artist': artist,
      'artist_image': artistImage,
      'artist_id': artistId,
      'genre': genre,
      'duration': duration,
      'stream_url': streamUrl,
      'play_count': playCount,
      'favorite_count': favoriteCount,
      'created_at': createdAt?.toIso8601String(),
      'artist_track_count': artistTrackCount,
      'artist_follower_count': artistFollowerCount,
    };
  }
}
