import 'package:flutter/material.dart';
import 'package:news_detail_app/provider/favorites_provider.dart';
import 'package:news_detail_app/provider/news_provider.dart';
import 'package:news_detail_app/screens/favorite_screen.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/news_detail_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (ctx) => HomeScreen(),
          AppRoutes.newsDetail: (ctx) => NewsDetailScreen(),
          AppRoutes.favorites: (ctx) => const FavoritesScreen(),
        },
      ),
    );
  }
}
