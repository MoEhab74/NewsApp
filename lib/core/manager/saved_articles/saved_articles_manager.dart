import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'dart:convert';

class SavedArticlesManager {
  static SavedArticlesManager? _instance;
  static SavedArticlesManager get instance => _instance ??= SavedArticlesManager._();
  
  SavedArticlesManager._();
  
  /// Get saved articles key for specific user
  String _getSavedKey(String userId) => 'saved_articles_$userId';
  
  /// Save article for user
  Future<void> saveArticle(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    
    final savedJson = prefs.getStringList(key) ?? [];
    
    // Check if article is already saved
    final articleJson = jsonEncode(article.toJson());
    if (savedJson.contains(articleJson)) {
      return; // Already saved
    }
    
    // Add to saved articles (add to beginning for most recent first)
    savedJson.insert(0, articleJson);
    await prefs.setStringList(key, savedJson);
  }
  
  /// Remove from saved articles
  Future<void> removeSavedArticle(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    
    // Get existing saved articles
    final savedJson = prefs.getStringList(key) ?? [];
    
    // Remove the article
    final articleJson = jsonEncode(article.toJson());
    savedJson.remove(articleJson);
    
    await prefs.setStringList(key, savedJson);
  }
  
  /// Check if article is saved
  Future<bool> isSaved(String userId, ArticleModel article) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    
    final savedJson = prefs.getStringList(key) ?? [];
    final articleJson = jsonEncode(article.toJson());
    
    return savedJson.contains(articleJson);
  }
  
  /// Get all saved articles for user
  Future<List<ArticleModel>> getSavedArticles(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    
    final savedJson = prefs.getStringList(key) ?? [];
    
    final savedArticles = <ArticleModel>[];
    for (final articleJsonString in savedJson) {
      try {
        final articleJson = jsonDecode(articleJsonString);
        final article = ArticleModel.fromJson(json: articleJson);
        savedArticles.add(article);
      } catch (e) {
        // Skip invalid entries
        continue;
      }
    }
    
    return savedArticles;
  }
  
  /// Clear all saved articles for user
  Future<void> clearSavedArticles(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    await prefs.remove(key);
  }
  
  /// Get saved articles count for user
  Future<int> getSavedArticlesCount(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getSavedKey(userId);
    final savedJson = prefs.getStringList(key) ?? [];
    return savedJson.length;
  }
}