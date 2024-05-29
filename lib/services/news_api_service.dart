import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  final String apiKey;

  NewsApiService(this.apiKey);

  Future<List<Article>> fetchArticles(String category,
      {String query = ''}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/top-headlines?category=$category&apiKey=$apiKey&q=$query'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
