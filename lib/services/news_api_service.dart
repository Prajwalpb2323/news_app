import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';
import '../models/article.dart';
import '../utils/constants.dart';

class NewsApiService {
  final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

  Future<List<Article>> getTopHeadlines({String? query}) async {
    try {
      final Uri uri = Uri.parse('${Constants.apiBaseUrl}${Constants.topHeadlinesEndpoint}')
          .replace(queryParameters: {
        'country': Constants.defaultCountry,
        'apiKey': apiKey,
        if (query != null && query.isNotEmpty) 'q': query,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}