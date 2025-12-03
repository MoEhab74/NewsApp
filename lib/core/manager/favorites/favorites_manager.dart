import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'dart:convert';

class FavoritesManager {
  static FavoritesManager? _instance;
  static FavoritesManager get instance => _instance ??= FavoritesManager._();
  
  FavoritesManager._();
  
  /// Get favorites key for specific user
  String _getFavoritesKey(String userId) => 'favorites_$userId';
  
  /// Save favorite article for user
  Future<void> addToFavorites(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    
    // Get existing favorites ( In the first time, it will be created as empty list )
    final favoritesJson = prefs.getStringList(key) ?? [];
    
    // Check if article is already in favorites
    final articleJson = jsonEncode(article.toJson()); // jsonEncode ===> Because SharedPreferences only supports String storage
    if (favoritesJson.contains(articleJson)) {
      return; // Already in favorites
    }
    
    // Add to favorites
    favoritesJson.add(articleJson);
    await prefs.setStringList(key, favoritesJson); // Update the favorites list with the new article
  }
  
  /// Remove from favorites
  Future<void> removeFromFavorites(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    
    // Get existing favorites
    final favoritesJson = prefs.getStringList(key) ?? [];
    
    // Remove the article
    final articleJson = jsonEncode(article.toJson());
    favoritesJson.remove(articleJson);
    
    await prefs.setStringList(key, favoritesJson);
  }
  
  /// Check if article is favorite
  Future<bool> isFavorite(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    
    final favoritesJson = prefs.getStringList(key) ?? [];
    final articleJson = jsonEncode(article.toJson());
    
    return favoritesJson.contains(articleJson);
  }
  
  /// Get all favorite articles for user
  Future<List<ArticleModel>> getFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    
    final favoritesJson = prefs.getStringList(key) ?? [];
    
    final favorites = <ArticleModel>[]; // 
    for (final articleJsonString in favoritesJson) {
      try {
        final articleJson = jsonDecode(articleJsonString); // jsonDecode ===> Convert from String to Map (because i passed the article through toJson before insert it to SharedPreferences)
        final article = ArticleModel.fromJson(json: articleJson);
        favorites.add(article);
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }
    
    return favorites;
  }
  
  /// Clear all favorites for user
  Future<void> clearFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    await prefs.remove(key);
  }
  
  /// Get favorites count for user
  Future<int> getFavoritesCount(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoritesKey(userId);
    final favoritesJson = prefs.getStringList(key) ?? [];
    return favoritesJson.length;
  }
}