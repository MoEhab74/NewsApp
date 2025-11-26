import 'package:flutter/material.dart';
import 'package:news_app/features/home/widgets/news_category.dart';
import 'package:news_app/features/home/models/article_model.dart';


class NewsListView extends StatelessWidget {
  final List<ArticleModel> articleNewsList;
  const NewsListView({super.key, required this.articleNewsList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return NewsCategory(article: articleNewsList[index]);
          }, childCount: articleNewsList.length),
        );
  }
}

// ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: newsList.length,
//       itemBuilder: (context, index) {
//         return NewsCategory(newsModel: newsList[index]);
//       },
//     );
