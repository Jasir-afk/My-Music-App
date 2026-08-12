class ArtistModel {
  final String? id;
  final String? name;
  final String? image;
  final int? trackCount;
  final int? followerCount;

  ArtistModel({
    this.id,
    this.name,
    this.image,
    this.trackCount,
    this.followerCount,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    // Handle image from profile_picture object
    String? imageUrl;
    final profilePic = json['profile_picture'];
    if (profilePic is Map) {
      imageUrl = profilePic['480x480']?.toString() ??
          profilePic['1000x1000']?.toString() ??
          profilePic['150x150']?.toString();
    } else {
      imageUrl = profilePic?.toString();
    }

    return ArtistModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      image: imageUrl,
      trackCount: json['track_count'] as int?,
      followerCount: json['follower_count'] as int?,
    );
  }

  factory ArtistModel.fromTrack(Map<String, dynamic> json) {
    // Extract artist info from track/user object
    String? imageUrl;
    final profilePic = json['user']?['profile_picture'];
    if (profilePic is Map) {
      imageUrl = profilePic['480x480']?.toString() ??
          profilePic['1000x1000']?.toString() ??
          profilePic['150x150']?.toString();
    }

    return ArtistModel(
      id: json['artist_id']?.toString() ?? json['user']?['id']?.toString(),
      name: json['artist']?.toString() ?? json['user']?['name']?.toString(),
      image: imageUrl,
      trackCount: json['user']?['track_count'] as int?,
      followerCount: json['user']?['follower_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'track_count': trackCount,
      'follower_count': followerCount,
    };
  }
}
