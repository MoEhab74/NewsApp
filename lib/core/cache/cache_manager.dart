import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/features/home/models/article_model.dart';

class CacheManager {
  static const String _cacheKey = 'news_cache';
  static const int _cacheExpiryHours = 24;

  /// Save articles to cache for a specific category
  static Future<void> saveArticles({
    required String category,
    required List<ArticleModel> articles,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get cache means access the data through the key of SharedPreferences
      // Return the cahe data as a map<String, dynamic>
      final existingCache = await _getCache();
      existingCache[category] = {
        // Save the articles as a list of json maps along with timestamp and category
        'articles': articles.map((article) => article.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'category': category,
      };
      // Save the updated cache as a string in SharedPreferences
      await prefs.setString(_cacheKey, jsonEncode(existingCache));
      log('Cached ${articles.length} articles for category: $category');
    } catch (e) {
      log('Error while saving cache: $e');
    }
  }

  /// Get all cached data
  /// Check if the _cachKey exists and has a data
  static Future<Map<String, dynamic>> _getCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheString = prefs.getString(_cacheKey);
      if (cacheString == null) {
        log('The first time to open the app, no cache found.');
        return {};
      }
      log('Cache data found after your request done.');
      return jsonDecode(cacheString) as Map<String, dynamic>;
    } on Exception catch (e) {
      log('Error while reading cache: $e');
      return {};
    }
  }

  /// Get articles from cache for a specific category
  /// This method will be called only when there is no internet connection
  static Future<List<ArticleModel>?> getArticles({
    required String category,
  }) async {
    try {
      final cache = await _getCache();
      // Access the data for the specific category
      final categoryData = cache[category];
      // If this category hasn't been cached before
      if (categoryData == null) {
        log('No cache found for category: $category');
        return null;
      }

      final timestamp = categoryData['timestamp'] as int; // Because it was saved as String
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final maxAge =
          _cacheExpiryHours * 60 * 60 * 1000; // Convert hours to milliseconds

      if (cacheAge > maxAge) {
        log('Cache expired for category: $category');
        await _removeCategoryFromCache(category);
        return null;
      }

      final articlesJson = categoryData['articles'] as List<dynamic>;
      final articles =
          articlesJson
              .map((json) => ArticleModel.fromJson(json: json))
              .toList();

      log(
        'Loaded ${articles.length} cached articles for category: $category',
      );
      return articles;
    } catch (e) {
      log('Error loading cache: $e');
      return null;
    }
  }

  /// Check if cached data exists for a category
  static Future<bool> hasCache({required String category}) async {
    final articles = await getArticles(category: category);
    return articles != null && articles.isNotEmpty;
  }

  /// Clear cache for a specific category
  static Future<void> clearCategory({required String category}) async {
    try {
      await _removeCategoryFromCache(category);
      log('Cleared cache for category: $category');
    } catch (e) {
      log('Error clearing category cache: $e');
    }
  }

  /// Clear all cached data
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      log('Cleared all news cache');
    } catch (e) {
      log('Error clearing all cache: $e');
    }
  }

  /// Remove a specific category from cache
  static Future<void> _removeCategoryFromCache(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingCache = await _getCache();

      existingCache.remove(category);

      if (existingCache.isEmpty) {
        // if there are no more categories, remove the entire cache
        await prefs.remove(_cacheKey);
      } else {
        // if there are still categories, update the cache without the removed one
        await prefs.setString(_cacheKey, jsonEncode(existingCache));
      }
    } catch (e) {
      log('Error removing category from cache: $e');
    }
  }

}
