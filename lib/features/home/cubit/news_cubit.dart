import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/home/cubit/news_states.dart';
import 'package:news_app/features/home/repo/news_repo.dart';
import 'package:news_app/core/services/app_response.dart';
import 'package:news_app/features/home/models/article_model.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepo _newsRepo;
  String _currentCategory = 'general';
  String? lastSearchKeyword = '';

  NewsCubit({NewsRepo? newsRepo})
    : _newsRepo = newsRepo ?? NewsRepo(Dio()),
      super(NewsInitialState());

  String get currentCategory => _currentCategory;

  /// Fetch top headlines for a specific category
  Future<void> getTopHeadlines({required String category}) async {
    emit(FetchTopHeadlinesLoadingState());

    try {
      AppResponse response = await _newsRepo.getTopHeadlines(
        category: category,
      );

      if (response.isSuccess && response.data is List<ArticleModel>) {
        _currentCategory = category;
        emit(
          FetchTopHeadlinesSuccessState(
            articles: response.data as List<ArticleModel>,
            category: category,
          ),
        );
      } else {
        emit(
          FetchTopHeadlinesErrorState(
            errorMessage: response.errorMessage ?? 'Failed to fetch news',
            category: category,
          ),
        );
      }
    } catch (e) {
      emit(
        FetchTopHeadlinesErrorState(
          errorMessage: 'Unexpected error: $e',
          category: category,
        ),
      );
    }
  }

  // Search articles by keyword
  Future<void> searchArticlesByKeyword({required String keyword}) async {
    emit(NewsLoadingState());

    try {
      AppResponse response = await _newsRepo.searchArticlesByKeyword(
        keyword: keyword,
      );

      if (response.isSuccess && response.data is List<ArticleModel>) {
        lastSearchKeyword = keyword;
        emit(
          SearchArticlesSuccessState(
            articles: response.data as List<ArticleModel>,
            keyword: keyword,
          ),
        );
        lastSearchKeyword = '';
      } else {
        emit(
          SearchArticlesErrorState(
            errorMessage: response.errorMessage ?? 'Failed to search articles',
            keyword: keyword,
          ),
        );
      }
    } catch (e) {
      emit(
        SearchArticlesErrorState(
          errorMessage: 'Unexpected error: $e',
          keyword: keyword,
        ),
      );
    }
  }

  /// Fetch news by category (same as getTopHeadlines but with different state)
  Future<void> fetchByCategory({required String category}) async {
    emit(FetchByCategoryLoadingState());

    try {
      AppResponse response = await _newsRepo.getTopHeadlines(
        category: category,
      );

      if (response.isSuccess && response.data is List<ArticleModel>) {
        _currentCategory = category;
        emit(
          FetchByCategorySuccessState(
            articles: response.data as List<ArticleModel>,
            category: category,
          ),
        );
      } else {
        emit(
          FetchByCategoryErrorState(
            errorMessage:
                response.errorMessage ?? 'Failed to fetch news for category',
            category: category,
          ),
        );
      }
    } catch (e) {
      emit(
        FetchByCategoryErrorState(
          errorMessage: 'Unexpected error: $e',
          category: category,
        ),
      );
    }
  }

  /// Select a category (for UI state management)
  void selectCategory({required String category}) {
    _currentCategory = category;
    emit(CategorySelectedState(selectedCategory: category));
  }

  /// Reset to initial state
  void resetState() {
    emit(NewsInitialState());
  }

  /// Refresh current news category
  Future<void> refreshNews() async {
    await getTopHeadlines(category: _currentCategory);
  }
}
