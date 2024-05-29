import 'package:flutter/material.dart';
import 'package:news_detail_app/utils/colors.dart';
import 'package:provider/provider.dart';

import '../provider/favorites_provider.dart';
import '../utils/strings.dart';
import '../widgets/news_list_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.appBarColor,
        title: const Text(
          Strings.favoritesText,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: favoritesProvider.favorites.isEmpty
          ? const Center(
              child: Text(
              Strings.noFavoritesText,
              style: TextStyle(color: AppColors.appBarColor),
            ))
          : ListView.builder(
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (context, index) {
                return NewsListItem(
                    article: favoritesProvider.favorites[index]);
              },
            ),
    );
  }
}
