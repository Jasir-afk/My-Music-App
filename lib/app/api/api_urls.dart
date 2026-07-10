class ApiMusic {
  static const String baseUrl = 'https://api.audius.co/v1';

  // OAuth endpoints
  static const String authorizeUrl = '$baseUrl/oauth/authorize';
  static const String tokenUrl = '$baseUrl/oauth/token';
  static const String redirectUrl = 'https://docs.audius.co/api/';

  // Track endpoints
  static const String trendingTracks = '$baseUrl/tracks/trending';
  static const String searchTracks = '$baseUrl/tracks/search';
  static const String latestTracks = '$baseUrl/tracks/latest';
  static const String mostLovedTracks = '$baseUrl/tracks/most_loved';
  static const String recommendedTracks = '$baseUrl/tracks/recommended';
  static const String trackDetails = '$baseUrl/tracks';
  static const String streamTrack = '/stream';

  // Notification endpoints
  static String notifications(String userId) =>
      '$baseUrl/notifications/$userId';
  static String playlistUpdates(String userId) =>
      '$baseUrl/notifications/$userId/playlist_updates';
}
