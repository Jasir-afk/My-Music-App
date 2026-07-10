import 'package:get/get.dart';
import 'package:my_musics/app/api/api_urls.dart';
import 'package:my_musics/app/api/dio_client.dart';
import 'package:my_musics/src/modules/notifications/model/notification_model.dart';

class NotificationService extends GetxController {
  static NotificationService get to => Get.find();

  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxList<PlaylistUpdateNotification> _playlistUpdates =
      <PlaylistUpdateNotification>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  List<NotificationModel> get notifications => _notifications;
  List<PlaylistUpdateNotification> get playlistUpdates => _playlistUpdates;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await DioClient.dio.get(ApiMusic.notifications(userId));

      if (response.data is List) {
        _notifications.value = (response.data as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else if (response.data['data'] is List) {
        _notifications.value = (response.data['data'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }

      return _notifications;
    } catch (e) {
      _error.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<PlaylistUpdateNotification>> getPlaylistUpdates(
    String userId,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await DioClient.dio.get(
        ApiMusic.playlistUpdates(userId),
      );

      if (response.data is List) {
        _playlistUpdates.value = (response.data as List)
            .map((json) => PlaylistUpdateNotification.fromJson(json))
            .toList();
      } else if (response.data['data'] is List) {
        _playlistUpdates.value = (response.data['data'] as List)
            .map((json) => PlaylistUpdateNotification.fromJson(json))
            .toList();
      }

      return _playlistUpdates;
    } catch (e) {
      _error.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          type: _notifications[index].type,
          title: _notifications[index].title,
          message: _notifications[index].message,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          metadata: _notifications[index].metadata,
        );
      }
    } catch (e) {
      _error.value = e.toString();
    }
  }

  Future<void> markPlaylistUpdateAsRead(String updateId) async {
    try {
      final index = _playlistUpdates.indexWhere((u) => u.id == updateId);
      if (index != -1) {
        _playlistUpdates[index] = PlaylistUpdateNotification(
          id: _playlistUpdates[index].id,
          userId: _playlistUpdates[index].userId,
          playlistId: _playlistUpdates[index].playlistId,
          playlistName: _playlistUpdates[index].playlistName,
          updateType: _playlistUpdates[index].updateType,
          trackTitle: _playlistUpdates[index].trackTitle,
          trackId: _playlistUpdates[index].trackId,
          createdAt: _playlistUpdates[index].createdAt,
          isRead: true,
        );
      }
    } catch (e) {
      _error.value = e.toString();
    }
  }

  void clearNotifications() {
    _notifications.clear();
  }

  void clearPlaylistUpdates() {
    _playlistUpdates.clear();
  }
}
