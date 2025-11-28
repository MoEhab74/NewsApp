import 'package:dio/dio.dart';
import 'package:news_app/core/services/app_response.dart';
import 'package:news_app/core/services/dio_helper.dart';
import 'package:news_app/features/home/models/article_model.dart';

class NewsRepo {
  final Dio dio;

  NewsRepo(this.dio);

  Future<AppResponse> getTopHeadlines({required String category}) async {
    try {
      Response response = await dio.get(
        '${DioHelper.baseUrl}category=$category',
      );

      // Convert the response data to json data
      Map<String, dynamic> jsonData = response.data;

      // Get the articles (data that i'm interested in) from the json data
      List<dynamic> articles = jsonData['articles'];

      // Convert the map of articles to a list of ArticleModel (Object type)
      List<ArticleModel> articlesList = [];

      for (var article in articles) {
        // You can use the ArticleModel class to create a list of articles
        articlesList.add(
          ArticleModel.fromJson(
            json: article,
          ), // Using the factory constructor to create an instance
        );
      }

      return AppResponse(
        isSuccess: true,
        data: articlesList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is DioException) {
        return AppResponse(
          isSuccess: false,
          exception: e,
          statusCode: e.response?.statusCode,
        );
      } else {
        return AppResponse(isSuccess: false, data: 'Failed to load news: $e');
      }
    }
  }

  // Search articles by keyword

  Future<AppResponse> searchArticlesByKeyword({required String keyword}) async {
    try {
      Response response = await dio.get(
        'https://newsapi.org/v2/everything?apiKey=63c8676c9e67443d958e27d471e8efaa&q=$keyword',
      );

      // Convert the response data to json data
      Map<String, dynamic> jsonData = response.data;

      // Get the articles (data that i'm interested in) from the json data
      List<dynamic> articles = jsonData['articles'];

      // Convert the map of articles to a list of ArticleModel (Object type)
      List<ArticleModel> articlesList = [];

      for (var article in articles) {
        // You can use the ArticleModel class to create a list of articles
        articlesList.add(
          ArticleModel.fromJson(
            json: article,
          ), // Using the factory constructor to create an instance
        );
      }

      return AppResponse(
        isSuccess: true,
        data: articlesList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is DioException) {
        return AppResponse(
          isSuccess: false,
          exception: e,
          statusCode: e.response?.statusCode,
        );
      } else {
        return AppResponse(isSuccess: false, data: 'Failed to load news: $e');
      }
    }
  }
}
