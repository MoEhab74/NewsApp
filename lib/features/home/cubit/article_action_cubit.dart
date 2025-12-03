import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/features/home/cubit/article_action_states.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/core/manager/favorites/favorites_manager.dart';
import 'package:news_app/core/manager/saved_articles/saved_articles_manager.dart';
import 'package:news_app/core/manager/user/user_manager.dart';

class ArticleActionCubit extends Cubit<ArticleActionState> {
  final FavoritesManager _favoritesManager;
  final SavedArticlesManager _savedArticlesManager;
  final UserManager _userManager;
  // Dependency Injection via constructor
  ArticleActionCubit({
    FavoritesManager? favoritesManager,
    SavedArticlesManager? savedArticlesManager,
    UserManager? userManager,
  }) : _favoritesManager = favoritesManager ?? FavoritesManager.instance,
       _savedArticlesManager =
           savedArticlesManager ?? SavedArticlesManager.instance,
       _userManager = userManager ?? UserManager.instance,
       super(ArticleActionInitialState());

  /// Toggle favorite status for an article
  Future<void> toggleFavorite(ArticleModel article) async {
    try {
      // Ensure user is initialized
      await _userManager.ensureUserInitialized();
      
      final userId = _userManager.currentUserId;
      
      log('ArticleActionCubit: toggleFavorite called');
      log('ArticleActionCubit: UserManager.currentUserId = $userId');
      log('ArticleActionCubit: UserManager.isAuthenticated = ${_userManager.isAuthenticated}');
      log('ArticleActionCubit: Firebase.currentUser = ${FirebaseAuth.instance.currentUser?.uid}');
      
      if (userId == null) {
        log('ArticleActionCubit: ERROR - User ID is still null after re-init!');
        emit(FavoriteErrorState(errorMessage: 'User not initialized'));
        return;
      }

      emit(ArticleActionLoadingState());

      final currentlyFavorite = await _favoritesManager.isFavorite(
        userId,
        article,
      );
      if (currentlyFavorite) {
        // True ===> Remove from favorites
        await _favoritesManager.removeFromFavorites(userId, article);
        emit(FavoriteToggledState(article: article, isFavorite: false));
      } else {
        // False ===> Add to favorites
        await _favoritesManager.addToFavorites(userId, article);
        emit(FavoriteToggledState(article: article, isFavorite: true));
      }

      // Emit updated status
      await _emitArticleStatus(article);
    } catch (e) {
      emit(FavoriteErrorState(errorMessage: 'Failed to toggle favorite: $e'));
    }
  }

  /// Toggle saved status for an article
  Future<void> toggleSaved(ArticleModel article) async {
    try {
      // Ensure user is initialized
      await _userManager.ensureUserInitialized();
      
      final userId = _userManager.currentUserId;
      
      log('ArticleActionCubit: toggleSaved called');
      log('ArticleActionCubit: UserManager.currentUserId = $userId');
      
      if (userId == null) {
        print('ArticleActionCubit: ERROR - User ID is still null after re-init for saved!');
        emit(SavedErrorState(errorMessage: 'User not initialized'));
        return;
      }

      emit(ArticleActionLoadingState());

      final currentlySaved = await _savedArticlesManager.isSaved(
        userId,
        article,
      );

      if (currentlySaved) {
        await _savedArticlesManager.removeSavedArticle(userId, article);
        emit(SavedToggledState(article: article, isSaved: false));
      } else {
        await _savedArticlesManager.saveArticle(userId, article);
        emit(SavedToggledState(article: article, isSaved: true));
      }

      // Emit updated status
      await _emitArticleStatus(article);
    } catch (e) {
      emit(SavedErrorState(errorMessage: 'Failed to toggle saved: $e'));
    }
  }

  /// Check the current status of an article (favorite and saved)
  Future<void> checkArticleStatus(ArticleModel article) async {
    try {
      final userId = _userManager.currentUserId;
      if (userId == null) {
        emit(
          ArticleStatusState(
            article: article,
            isFavorite: false,
            isSaved: false,
          ),
        );
        return;
      }

      final isFavorite = await _favoritesManager.isFavorite(userId, article);
      final isSaved = await _savedArticlesManager.isSaved(userId, article);

      emit(
        ArticleStatusState(
          article: article,
          isFavorite: isFavorite,
          isSaved: isSaved,
        ),
      );
    } catch (e) {
      // Emit default state on error
      emit(
        ArticleStatusState(article: article, isFavorite: false, isSaved: false),
      );
    }
  }

  /// Helper method to emit current status
  Future<void> _emitArticleStatus(ArticleModel article) async {
    final userId = _userManager.currentUserId;
    if (userId == null) return;

    final isFavorite = await _favoritesManager.isFavorite(userId, article);
    final isSaved = await _savedArticlesManager.isSaved(userId, article);

    emit(
      ArticleStatusState(
        article: article,
        isFavorite: isFavorite,
        isSaved: isSaved,
      ),
    );
  }

  /// Get all favorites for current user
  Future<List<ArticleModel>> getFavorites() async {
    final userId = _userManager.currentUserId;
    if (userId == null) return [];

    return await _favoritesManager.getFavorites(userId);
  }

  /// Get all saved articles for current user
  Future<List<ArticleModel>> getSavedArticles() async {
    final userId = _userManager.currentUserId;
    if (userId == null) return [];

    return await _savedArticlesManager.getSavedArticles(userId);
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    final userId = _userManager.currentUserId;
    if (userId == null) return;

    await _favoritesManager.clearFavorites(userId);
    emit(FavoritesClearedState());
  }

  /// Clear all saved articles
  Future<void> clearSavedArticles() async {
    final userId = _userManager.currentUserId;
    if (userId == null) return;

    await _savedArticlesManager.clearSavedArticles(userId);
    emit(SavedArticlesClearedState());
  }
}
