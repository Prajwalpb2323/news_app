import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';

enum NewsLoadingStatus { initial, loading, loaded, error }

class NewsProvider extends ChangeNotifier {
  final NewsApiService _newsService = NewsApiService();

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  NewsLoadingStatus _status = NewsLoadingStatus.initial;
  NewsLoadingStatus get status => _status;

  Future<void> fetchTopHeadlines({String? query}) async {
    try {
      _status = NewsLoadingStatus.loading;
      notifyListeners();

      _articles = await _newsService.getTopHeadlines(query: query);

      if (_articles.isEmpty && query != null) {
        throw Exception('No results found for "$query"');
      }

      _status = NewsLoadingStatus.loaded;
    } catch (e) {
      _status = NewsLoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// ✅ **Fixed `refreshNews()` to correctly fetch fresh news**
  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }
}
