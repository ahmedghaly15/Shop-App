import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        headers: {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String pathUrl,
    required Map<String, dynamic> queries,
    String? lang = 'ar',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token,
    };
    return await dio!.get(pathUrl, queryParameters: queries);
  }

  static Future<Response> postData({
    required String pathUrl,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queries,
    String? lang = 'ar',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token,
    };
    return await dio!.post(
      pathUrl,
      queryParameters: queries,
      data: data,
    );
  }
}
