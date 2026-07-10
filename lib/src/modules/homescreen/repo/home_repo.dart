import 'package:my_musics/app/api/api_urls.dart';
import 'package:my_musics/app/api/dio_client.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';

class HomeRepository {
  /// Get trending songs
  Future<List<TrackModel>> getTrendingSongs({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.trendingTracks,
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch trending songs: $e');
    }
  }

  /// Search songs
  Future<List<TrackModel>> searchTracks(String query) async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.searchTracks,
        queryParameters: {'query': query, 'limit': 20},
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search tracks: $e');
    }
  }

  /// Get latest songs
  Future<List<TrackModel>> getLatestSongs() async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.latestTracks,
        queryParameters: {'limit': 20},
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch latest songs: $e');
    }
  }

  /// Get most loved songs
  Future<List<TrackModel>> getMostLovedSongs() async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.mostLovedTracks,
        queryParameters: {'limit': 20},
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch most loved songs: $e');
    }
  }

  /// Get recommended songs
  Future<List<TrackModel>> getRecommendedSongs() async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.recommendedTracks,
        queryParameters: {'limit': 20},
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch recommended songs: $e');
    }
  }

  /// Get song details by ID
  Future<TrackModel?> getTrackDetails(String trackId) async {
    try {
      final response = await DioClient.dio.get(
        '${ApiMusic.trackDetails}/$trackId',
      );

      if (response.data['data'] != null) {
        return TrackModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch track details: $e');
    }
  }

  /// Get stream URL for a song
  Future<String?> getStreamUrl(String trackId) async {
    try {
      final response = await DioClient.dio.get(
        '${ApiMusic.trackDetails}/$trackId${ApiMusic.streamTrack}',
      );

      if (response.data['data'] != null) {
        return response.data['data']['stream_url']?.toString();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch stream URL: $e');
    }
  }

  /// Get songs by artist
  Future<List<TrackModel>> getSongsByArtist({
    required String artistName,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.searchTracks,
        queryParameters: {
          'query': artistName,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch artist songs: $e');
    }
  }
}
