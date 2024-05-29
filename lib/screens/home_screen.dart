import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';
import '../utils/app_routes.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../widgets/news_list_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'general';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchArticles();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchArticles();
    }
  }

  void _fetchArticles() {
    Provider.of<NewsProvider>(context, listen: false)
        .fetchArticles(_selectedCategory, query: _searchQuery);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: const Text(
          Strings.title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: AppColors.red,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.favorites);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildCategoryDropdown(),
          Expanded(
            child: newsProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ))
                : newsProvider.hasError
                    ? const Center(child: Text(Strings.failedTextMessage))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: newsProvider.articles.length,
                        itemBuilder: (context, index) {
                          return NewsListItem(
                              article: newsProvider.articles[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

//TODO: Search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: Strings.searchText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text;
                  _fetchArticles();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
                _fetchArticles();
              });
            },
            items: <String>[
              'business',
              'entertainment',
              'general',
              'health',
              'science',
              'sports',
              'technology'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value[0].toUpperCase() + value.substring(1)),
              );
            }).toList(),
            isExpanded: true,
            // Makes the dropdown take the full width
            icon: const Icon(Icons.arrow_drop_down), // Custom dropdown icon
          ),
        ),
      ),
    );
  }
}
