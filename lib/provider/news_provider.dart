import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<Article> get articles => _articles;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  Future<void> fetchArticles(String category, {String query = ''}) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?category=$category&q=$query&apiKey=4ea3f552ce68406986b89462dab80d1d');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        _articles = articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        _hasError = true;
      }
    } catch (error) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }
}
