import 'package:frontend/model/auth_token.dart';
import 'package:frontend/model/error_message.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class Api {
  final GetStorage _getStorage = GetStorage();

  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.29.245:3000/api',
      responseType: ResponseType.json,
      contentType: 'application/json'));

  Future<Map<String, dynamic>> isLoggedIn(Map<String, String> userCred) async {
    try {
      final response = await _dio.post('/login', data: userCred);
      final tokens = tokenModelFromJsonFromJson(response.toString());
      print(response);

      // storing in local storage
      _getStorage.write("access_token", tokens.accessToken);
      _getStorage.write("refresh_token", tokens.refreshToken);

      return {"error": null, "loggedIn": true};
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        print(e.response);
        return {
          "error": errorMessageFromJson(e.response.toString()).message,
          "loggedIn": false
        };
      } else {
        return {
          "error": errorMessageFromJson(e.response.toString()).message,
          "loggedIn": false
        };
      }
    } catch (e) {
      return {"error": 'Internal Server Error', "loggedIn": false};
    }
  }

  Future<Response<dynamic>> makeRequest(String path) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept'] = "application/json";
        String? token = _getStorage.read("access_token");
        options.headers["authorization"] = "Bearer $token";
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshToken = _getStorage.read("refresh_token");
          final response = await _dio
              .post('/refresh-token', data: {'refresh_token': refreshToken});

          final newAccessToken = response.data['access_token'];
          _getStorage.write("access_token", newAccessToken);
          if (newAccessToken != null) {
            _dio.options.headers["authorization"] = "Bearer $newAccessToken";
            return handler.resolve(await _dio.fetch(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
    return _dio.get(path);
  }
}
