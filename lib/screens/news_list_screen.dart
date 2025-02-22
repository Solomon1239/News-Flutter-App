import 'package:flutter/material.dart';
import '../repository/news_repository.dart';
import '../models/news.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsRepository repository = NewsRepository();
  late Future<List<News>> _newsFuture;
  List<News> _allNews = [];
  List<News> _filteredNews = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _newsFuture = repository.fetchNews();
    _newsFuture.then((posts) {
      setState(() {
        _allNews = posts;
        _filteredNews = posts;
      });
    });
  }

  void _filterNews(String query) {
    final filtered = _allNews
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchQuery = query;
      _filteredNews = filtered;
    });
  }

  Future<void> _refreshNews() async {
    _loadNews();
    await _newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _filterNews,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Поиск по заголовку',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).iconTheme.color),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || _filteredNews.isEmpty) {
            return const Center(child: Text('Нет данных'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshNews,
              child: ListView.builder(
                itemCount: _filteredNews.length,
                itemBuilder: (context, index) {
                  final post = _filteredNews[index];
                  final description = post.body.length > 100
                      ? '${post.body.substring(0, 100)}...'
                      : post.body;
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        post.title.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
