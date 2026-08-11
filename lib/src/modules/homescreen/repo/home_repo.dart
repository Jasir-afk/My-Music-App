import 'package:my_musics/app/network/api/api_urls.dart';
import 'package:my_musics/app/network/api/dio_client.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';
import 'package:my_musics/src/modules/homescreen/model/artist_model.dart';

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

  /// Get related songs by artist (excluding current song)
  Future<List<TrackModel>> getRelatedSongsByArtist({
    required String artistName,
    String? excludeTrackId,
    int limit = 10,
  }) async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.searchTracks,
        queryParameters: {
          'query': artistName,
          'limit': limit + 5, // Fetch extra to account for excluded track
        },
      );

      if (response.data['data'] != null) {
        var songs = (response.data['data'] as List)
            .map((json) => TrackModel.fromJson(json))
            .toList();

        // Exclude the current track if specified
        if (excludeTrackId != null) {
          songs = songs.where((song) => song.id != excludeTrackId).toList();
        }

        // Limit to requested number
        return songs.take(limit).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch related songs: $e');
    }
  }

  /// Search artists
  Future<List<ArtistModel>> searchArtists(String query) async {
    try {
      final response = await DioClient.dio.get(
        ApiMusic.searchTracks,
        queryParameters: {'query': query, 'limit': 20},
      );

      if (response.data['data'] != null) {
        // Extract unique artists from search results
        final artists = <ArtistModel>[];
        final seenArtistIds = <String>{};

        for (var json in response.data['data'] as List) {
          final artistId =
              json['artist_id']?.toString() ?? json['user']?['id']?.toString();
          if (artistId != null && !seenArtistIds.contains(artistId)) {
            seenArtistIds.add(artistId);
            artists.add(ArtistModel.fromTrack(json));
          }
        }

        return artists;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search artists: $e');
    }
  }
}
