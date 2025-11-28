import 'package:dio/dio.dart';
import 'package:news_app/core/services/app_response.dart';

class DioHelper {
  static const String baseUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=df5f5f637290450395c76fdb73e51c6c&';
  Dio? _dio;
  DioHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        // connectTimeout: const Duration(seconds: 20),
        // receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }

  Future<AppResponse> getData(String path) async {
    try {
      final response = await _dio!.get(path);
      if (response.statusCode == 200) {
        return AppResponse(
          isSuccess: true,
          data: response.data,
          statusCode: response.statusCode,
        );
      } else {
        return AppResponse(
          isSuccess: false,
          data: response.data,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return AppResponse(
        isSuccess: false,
        exception: e,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
