// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:news_app/Widgets/news_category.dart';
// import 'package:news_app/models/article_model.dart';
// import 'package:news_app/models/news_model.dart';
// import 'package:news_app/services/news_services.dart';

// class NewsListView extends StatefulWidget {
//   const NewsListView({super.key});

//   @override
//   State<NewsListView> createState() => _NewsListViewState();
// }

// class _NewsListViewState extends State<NewsListView> {
//   List<ArticleModel> articleNewsList = [];
//   bool isLoading = true;


//   @override
//   void initState() {
//     super.initState();
//     getGeneralNews(); // Trigger the API call to fetch news
//   }

//   // This function is used to get the news from the API
//   // You can use it in the initState() method to get the news when the widget is created
//   Future<void> getGeneralNews() async {
//     articleNewsList = await NewsServices(Dio()).getNews();
//     isLoading = false; // Set loading to false after fetching the news
//     // Rebuild the widget to show the news
//     // setState is used to notify the flutter that the state of the widget has changed
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? SliverFillRemaining(
//           hasScrollBody: false, // Prevents scrolling when loading
//           child: Center(child: const CircularProgressIndicator()),
//         )
//         : SliverList(
//           delegate: SliverChildBuilderDelegate((context, index) {
//             return NewsCategory(article: articleNewsList[index]);
//           }, childCount: articleNewsList.length),
//         );
//   }
// }

// // ListView.builder(
// //       shrinkWrap: true,
// //       physics: NeverScrollableScrollPhysics(),
// //       itemCount: newsList.length,
// //       itemBuilder: (context, index) {
// //         return NewsCategory(newsModel: newsList[index]);
// //       },
// //     );
