import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

class FavoritesProvider with ChangeNotifier {
  List<Article> _favorites = [];

  List<Article> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  void toggleFavorite(Article article) {
    if (_favorites.any((fav) => fav.url == article.url)) {
      _favorites.removeWhere((fav) => fav.url == article.url);
    } else {
      _favorites.add(article);
    }
    saveFavorites();
    notifyListeners();
  }

  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _favorites.map((article) => article.toJson()).toList(),
    );
    prefs.setString('favorites', encodedData);
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      final List<dynamic> favoritesJson = jsonDecode(favoritesString);
      _favorites = favoritesJson.map((json) => Article.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
