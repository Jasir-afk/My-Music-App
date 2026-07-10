import 'package:get/get.dart';
import 'package:my_musics/app/api/api_urls.dart';
import 'package:my_musics/app/api/dio_client.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  final RxBool _isLoggedIn = false.obs;
  final RxString _accessToken = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  String get accessToken => _accessToken.value;

  void login() {
    _isLoggedIn.value = true;
  }

  void logout() {
    _isLoggedIn.value = false;
    _accessToken.value = '';
  }

  // OAuth methods for Audius
  Future<String> getAuthorizeUrl({
    required String clientId,
    required String redirectUri,
  }) async {
    final response = await DioClient.dio.get(
      ApiMusic.authorizeUrl,
      queryParameters: {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'response_type': 'code',
      },
    );
    return response.data['authorize_url'] ?? '';
  }

  Future<void> exchangeCodeForToken({
    required String code,
    required String clientId,
    required String clientSecret,
  }) async {
    final response = await DioClient.dio.post(
      ApiMusic.tokenUrl,
      data: {
        'grant_type': 'authorization_code',
        'code': code,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    _accessToken.value = response.data['access_token'] ?? '';
    _isLoggedIn.value = true;
  }
}
