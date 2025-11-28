import 'package:dio/dio.dart';

class AppResponse {
  final bool isSuccess;
  final dynamic data;
  final DioException? exception;
  final int? statusCode;
  String? errorMessage;

  AppResponse({
    required this.isSuccess,
    this.data,
    this.exception,
    this.statusCode,
  }) {
    if (data != null) {
      if (data is Map && data.containsKey('message')) {
        errorMessage = data['message'].toString();
      } else if (data is String) {
        errorMessage = data;
      } else {
        errorMessage =
            exception?.response?.data['message'] ?? exception?.message;
      }
    } else if (exception != null && errorMessage == null) {
      final exData = exception!.response?.data;

      if (exData is Map && exData.containsKey('message')) {
        errorMessage = exData['message'].toString();
      } else if (exData is String) {
        errorMessage = exData;
      } else {
        errorMessage = exception!.message;
      }
    } else {
      errorMessage ??= "Unknown error occurred";
    }
  }
}
