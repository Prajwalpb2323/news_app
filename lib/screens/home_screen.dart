import 'package:flutter/material.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart'; // ✅ Import ThemeProvider
import '../widgets/article_list_item.dart';
import '../widgets/error_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchTopHeadlines();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<NewsProvider>().fetchTopHeadlines(query: query).then((_) {
        setState(() {}); // ✅ Update UI after search
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching search results: $error')),
        );
      });
    } else {
      context.read<NewsProvider>().fetchTopHeadlines().then((_) {
        setState(() {}); // ✅ Reset to default news
      });
    }
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<NewsProvider>().fetchTopHeadlines().then((_) {
      setState(() {
        _isSearching = false;
      });
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // ✅ Theme Provider

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
          ),
          onSubmitted: (_) => _performSearch(),
        )
            : const Text('Top Headlines'),
        actions: [
          // ✅ Theme Toggle Button
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode // ☀ Light Mode
                  : Icons.dark_mode, // 🌙 Dark Mode
            ),
            onPressed: () {
              themeProvider.toggleTheme(); // ✅ Toggle theme
            },
          ),

          // ✅ Search Button
          IconButton(
            icon: Icon(_isSearching ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  _searchFocusNode.requestFocus();
                } else {
                  _clearSearch();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          switch (newsProvider.status) {
            case NewsLoadingStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case NewsLoadingStatus.error:
              return ErrorMessage(
                message: newsProvider.errorMessage,
                onRetry: () => newsProvider.refreshNews(),
              );

            case NewsLoadingStatus.loaded:
              if (newsProvider.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.article_outlined, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No articles found',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (_isSearching)
                        Text(
                          'Try a different search term',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: newsProvider.refreshNews,
                child: ListView.builder(
                  itemCount: newsProvider.articles.length,
                  itemBuilder: (context, index) {
                    final article = newsProvider.articles[index];
                    return ArticleListItem(
                      article: article,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                    );
                  },
                ),
              );

            case NewsLoadingStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
