import 'package:news_app/features/home/models/article_model.dart';

// Base state class
abstract class NewsState {}

// Initial state
class NewsInitialState extends NewsState {}

// Loading states
class NewsLoadingState extends NewsState {}

class FetchTopHeadlinesLoadingState extends NewsState {}

class FetchByCategoryLoadingState extends NewsState {}

// Success states
class NewsSuccessState extends NewsState {
  final List<ArticleModel> articles;
  final String? successMessage;

  NewsSuccessState({
    required this.articles,
    this.successMessage,
  });
}

class FetchTopHeadlinesSuccessState extends NewsState {
  final List<ArticleModel> articles;
  final String category;
  final bool isFromCache;

  FetchTopHeadlinesSuccessState({
    required this.articles,
    required this.category,
    this.isFromCache = false,
  });
}

class SearchArticlesLoadingState extends NewsState {}

class SearchArticlesSuccessState extends NewsState {
  final List<ArticleModel> articles;
  final String keyword;

  SearchArticlesSuccessState({
    required this.articles,
    required this.keyword,
  });
}

class SearchArticlesErrorState extends NewsState {
  final String errorMessage;
  final String keyword;

  SearchArticlesErrorState({
    required this.errorMessage,
    required this.keyword,
  });
}

class FetchByCategorySuccessState extends NewsState {
  final List<ArticleModel> articles;
  final String category;

  FetchByCategorySuccessState({
    required this.articles,
    required this.category,
  });
}

// Error states
class NewsErrorState extends NewsState {
  final String errorMessage;

  NewsErrorState({
    required this.errorMessage,
  });
}

class FetchTopHeadlinesErrorState extends NewsState {
  final String errorMessage;
  final String category;

  FetchTopHeadlinesErrorState({
    required this.errorMessage,
    required this.category,
  });
}

class FetchByCategoryErrorState extends NewsState {
  final String errorMessage;
  final String category;

  FetchByCategoryErrorState({
    required this.errorMessage,
    required this.category,
  });
}

// Category selection state