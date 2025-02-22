import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsRepository {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки новостей');
    }
  }
}
