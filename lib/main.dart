import 'package:flutter/material.dart';
//  import 'package:news_app/services/news_services.dart';
import 'package:news_app/features/views/home_view.dart';
import 'package:dio/dio.dart';

void main() {
//  NewsServices(Dio()).getNews(); // Initialize the NewsServices and call getNews method
  runApp(const MyApp());
}
final dio = Dio();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

