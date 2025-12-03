import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:news_app/core/services/app_response.dart';
import 'package:news_app/core/services/dio_helper.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/core/cache/cache_manager.dart';
import 'package:news_app/core/services/connectivity_service.dart';

class NewsRepo {
  final Dio dio;

  NewsRepo(this.dio);

  Future<AppResponse> getTopHeadlines({required String category}) async {
    // Check internet connectivity first
    final hasInternet = await ConnectivityService.hasInternetConnection();
    
    if (!hasInternet) {
      log('No internet connection, loading from cache for category: $category');
      
      // No internet, try to get from cache
      final cachedArticles = await CacheManager.getArticles(category: category);
      
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        log('Loading ${cachedArticles.length} cached articles for $category');
        return AppResponse(
          isSuccess: true,
          data: cachedArticles,
          statusCode: 200,
        )
          ..errorMessage = 'CACHE_DATA'; // Special marker for cache data
      } else {
        log('No cached data available for category: $category');
        return AppResponse(
          isSuccess: false,
          data: 'No internet connection and no cached data available',
        );
      }
    }

    // Internet is available, fetch from API
    try {
      log('Internet available, fetching fresh data for category: $category');
      
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
        // Skip articles with missing title or url
        if (article['title'] == null || article['url'] == null) {
          log('Skipping article with missing title or URL');
          continue;
        }
        
        // You can use the ArticleModel class to create a list of articles
        articlesList.add(
          ArticleModel.fromJson(
            json: article,
          ), // Using the factory constructor to create an instance
        );
      }

      // Save to cache on successful API call
      await CacheManager.saveArticles(
        category: category,
        articles: articlesList,
      );
      
      log('Successfully fetched and cached ${articlesList.length} articles for $category');

      return AppResponse(
        isSuccess: true,
        data: articlesList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      log('API call failed even with internet: $e');
      
      // API failed but internet is available, try cache as backup
      final cachedArticles = await CacheManager.getArticles(category: category);
      
      if (cachedArticles != null && cachedArticles.isNotEmpty) {
        log('API failed, falling back to ${cachedArticles.length} cached articles for $category');
        return AppResponse(
          isSuccess: true,
          data: cachedArticles,
          statusCode: 200,
        )
          ..errorMessage = 'CACHE_DATA'; // Special marker for cache data
      }
      
      // No cache available, return error
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
    // Check internet connectivity first
    final hasInternet = await ConnectivityService.hasInternetConnection();
    
    if (!hasInternet) {
      log('No internet connection, search requires internet access');
      return AppResponse(
        isSuccess: false,
        data: 'Search requires internet connection. Please check your connection and try again.',
      );
    }

    // Internet is available, search from API
    try {
      log('Searching for articles with keyword: $keyword');
      
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
        // Skip articles with missing title or url
        if (article['title'] == null || article['url'] == null) {
          log('Skipping article with missing title or URL');
          continue;
        }
        
        // You can use the ArticleModel class to create a list of articles
        articlesList.add(
          ArticleModel.fromJson(
            json: article,
          ), // Using the factory constructor to create an instance
        );
      }

      log('Successfully found ${articlesList.length} articles for keyword: $keyword');

      return AppResponse(
        isSuccess: true,
        data: articlesList,
        statusCode: response.statusCode,
      );
    } catch (e) {
      log('Search failed: $e');
      if (e is DioException) {
        return AppResponse(
          isSuccess: false,
          exception: e,
          statusCode: e.response?.statusCode,
        );
      } else {
        return AppResponse(isSuccess: false, data: 'Failed to search articles: $e');
      }
    }
  }
}
