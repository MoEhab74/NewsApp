import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/features/home/repo/news_repo.dart';
import 'package:news_app/core/services/app_response.dart';

class NewsServices {
  final NewsRepo _newsRepo;
  
  NewsServices(Dio dio) : _newsRepo = NewsRepo(dio);
  // You can use this line ===> final Dio dio = Dio(); instead of passing it in the constructor

  /// Service layer method that delegates to the repository
  /// Returns a list of articles for backward compatibility
  Future<List<ArticleModel>> getTopHeadLines({required String category}) async {
    try {
      AppResponse response = await _newsRepo.getTopHeadlines(category: category);
      
      if (response.isSuccess && response.data is List<ArticleModel>) {
        return response.data as List<ArticleModel>;
      } else {
        // Log error or handle it as needed
        log('Error fetching news: ${response.errorMessage}');
        return []; // Return an empty list if there is an error
      }
    } catch (e) {
      log('Unexpected error in NewsServices: $e');
      return []; // Return an empty list if there is an error
    }
  }

  // search articles by keyword
  Future<List<ArticleModel>> searchArticlesByKeyword({required String keyword}) async {
    try {
      AppResponse response = await _newsRepo.searchArticlesByKeyword(keyword: keyword);
      
      if (response.isSuccess && response.data is List<ArticleModel>) {
        return response.data as List<ArticleModel>;
      } else {
        // Log error or handle it as needed
        log('Error searching articles: ${response.errorMessage}');
        return []; // Return an empty list if there is an error
      }
    } catch (e) {
      log('Unexpected error in NewsServices (search): $e');
      return []; // Return an empty list if there is an error
    }
  }
}
