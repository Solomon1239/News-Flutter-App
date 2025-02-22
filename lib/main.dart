import 'package:flutter/material.dart';
import 'screens/news_list_screen.dart';
import 'themes/light_theme.dart';
import 'themes/dark_theme.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: modernLightTheme,
      darkTheme: elegantDarkTheme,
      themeMode: ThemeMode.system,
      home: const NewsListScreen(),
    );
  }
}
