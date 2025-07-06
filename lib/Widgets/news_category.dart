import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/views/web_view.dart';

// import 'package:news_app/models/news_model.dart';

class NewsCategory extends StatelessWidget {
  const NewsCategory({required this.article, super.key});

  // final NewsModel newsModel;
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(body: WebviewPage(url: article.url)),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article.image ??
                    "https://ichef.bbci.co.uk/news/1024/branded_arabic/c82a/live/98939210-432e-11f0-b6e6-4ddb91039da1.png",
                fit: BoxFit.cover,
                height: 300,
                //width: double.infinity,
              ),
            ),
          ),

          // Another way instead of using ClipRRect
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 20.0,
          //     left: 8.0,
          //     right: 8.0,
          //     bottom: 8.0,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     height: 300,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       image: DecorationImage(
          //         image: AssetImage(newsModel.image),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     // child: Image.asset('assets/sports.avif', fit: BoxFit.cover),
          //   ),
          // ),
          ListTile(
            title: Text(
              article.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              article.subTitle ?? "No subTitle available",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
