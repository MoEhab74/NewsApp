import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/ui/custom_indicator.dart';
import 'package:news_app/core/ui/error_message.dart';
import 'package:news_app/features/home/widgets/news_list_view.dart';
import 'package:news_app/features/home/models/article_model.dart';
import 'package:news_app/core/services/news_services.dart';

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




