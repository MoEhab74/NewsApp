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
    final mq = MediaQuery.of(context).size;
    final imageHeight = (mq.height * 0.35).clamp(180.0, 400.0);

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
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.image == null || article.image!.isEmpty
                      ? 'https://ichef.bbci.co.uk/news/1024/branded_arabic/c82a/live/98939210-432e-11f0-b6e6-4ddb91039da1.png'
                      : article.image!,
                  fit: BoxFit.contain,
                  height: imageHeight,
                  // constrain width so it doesn't span the whole screen on web
                  width: (MediaQuery.of(context).size.width * 0.9).clamp(300.0, MediaQuery.of(context).size.width),
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: imageHeight,
                    width: (MediaQuery.of(context).size.width * 0.9).clamp(300.0, MediaQuery.of(context).size.width),
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: imageHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
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
              textAlign: TextAlign.center,
              article.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              textAlign: TextAlign.center,
              article.subTitle ?? "No subTitle available",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
