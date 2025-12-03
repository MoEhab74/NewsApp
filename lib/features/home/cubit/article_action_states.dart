import 'package:news_app/features/home/models/article_model.dart';

abstract class ArticleActionState {}

class ArticleActionInitialState extends ArticleActionState {}

class ArticleActionLoadingState extends ArticleActionState {}

// Favorite states
class FavoriteToggledState extends ArticleActionState {
  final ArticleModel article;
  final bool isFavorite;
  
  FavoriteToggledState({
    required this.article,
    required this.isFavorite,
  });
}

class FavoriteErrorState extends ArticleActionState {
  final String errorMessage;
  
  FavoriteErrorState({required this.errorMessage});
}

// Saved articles states
class SavedToggledState extends ArticleActionState {
  final ArticleModel article;
  final bool isSaved;
  
  SavedToggledState({
    required this.article,
    required this.isSaved,
  });
}

class SavedErrorState extends ArticleActionState {
  final String errorMessage;
  
  SavedErrorState({required this.errorMessage});
}

// Combined status state (for UI to check current status)
class ArticleStatusState extends ArticleActionState {
  final ArticleModel article;
  final bool isFavorite;
  final bool isSaved;
  
  ArticleStatusState({
    required this.article,
    required this.isFavorite,
    required this.isSaved,
  });
}

// Clear states
class FavoritesClearedState extends ArticleActionState {}

class SavedArticlesClearedState extends ArticleActionState {}