class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class PlaylistUpdateNotification {
  final String id;
  final String userId;
  final String playlistId;
  final String playlistName;
  final String updateType;
  final String? trackTitle;
  final String? trackId;
  final DateTime createdAt;
  final bool isRead;

  PlaylistUpdateNotification({
    required this.id,
    required this.userId,
    required this.playlistId,
    required this.playlistName,
    required this.updateType,
    this.trackTitle,
    this.trackId,
    required this.createdAt,
    this.isRead = false,
  });

  factory PlaylistUpdateNotification.fromJson(Map<String, dynamic> json) {
    return PlaylistUpdateNotification(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      playlistId: json['playlist_id'] ?? '',
      playlistName: json['playlist_name'] ?? '',
      updateType: json['update_type'] ?? '',
      trackTitle: json['track_title'],
      trackId: json['track_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'playlist_id': playlistId,
      'playlist_name': playlistName,
      'update_type': updateType,
      'track_title': trackTitle,
      'track_id': trackId,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
