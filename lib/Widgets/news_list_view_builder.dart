import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Widgets/news_list_view.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/news_services.dart';

class NewsListViewBuilder extends StatefulWidget {
  const NewsListViewBuilder({super.key, required this.category});
  final String category;

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  var futureData;
  // Future<List<ArticleModel>>? futureData; // Use this instead of detremine the type in the FutureBuilder
  @override
  void initState() {
    super.initState();
    futureData = NewsServices(Dio()).getTopHeadLines(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NewsListView(articleNewsList: snapshot.data!);
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ErrorMessage(
                errorMessage:
                    'No news available at the moment.\n'
                    'Please check your internet connection or try again later.\n',
              ),
            ),
          );
        } else {
          return SliverFillRemaining(
            hasScrollBody: false, // Prevents scrolling when loading
            child: Center(child: CustomIndicator()),
          );
        }
      },
    );
  }
}

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
    );
  }
}
