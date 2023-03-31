import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  //============= For Initializing Dio =============
  static initDio() {
    dio = Dio(
      BaseOptions(
        // Base Url We Are Working On
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  //============= For Getting Some Data Using Dio According To Its pathUrl =============
  static Future<Response> getData({
    required String pathUrl,
    Map<String, dynamic>? queries,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio.get(pathUrl, queryParameters: queries);
  }

  //============= For Adding New Data Using Dio According To Its pathUrl =============
  static Future<Response> postData({
    required String pathUrl,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queries,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio.post(
      pathUrl,
      queryParameters: queries,
      data: data,
    );
  }

  //============= For Updating Some Data Using Dio According To Its pathUrl =============
  static Future<Response> putData({
    required String pathUrl,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queries,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio.put(
      pathUrl,
      queryParameters: queries,
      data: data,
    );
  }
}
