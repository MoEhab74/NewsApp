import 'package:dio/dio.dart';
import 'package:news_app/models/article_model.dart';

class NewsServices {
  final Dio dio;
  NewsServices(this.dio);
  // You can use this line ===> final Dio dio = Dio(); instead of passing it in the constructor

  Future<List<ArticleModel>> getTopHeadLines({required String category}) async {
    // Example of a GET request
    try {
      Response response = await dio.get(
    'https://newsapi.org/v2/top-headlines?country=us&apiKey=df5f5f637290450395c76fdb73e51c6c&category=$category',
  );
  // Convert the response data to json data
  Map<String, dynamic> jasonData =
      response.data; // Dynamic type because the data can be anything
  // Get the articles (data that i'm interested in) from the json data
  List<dynamic> articles = jasonData['articles'];
  // Convert the map of articles to a list of ArticleModel (Object type)
  List<ArticleModel> articlesList = [];
  
  for (var article in articles) {
    // You can use the ArticleModel class to create a list of articles
    articlesList.add(
      ArticleModel.fromJson(json: article), // Using the factory constructor to create an instance
    );
  }
  return articlesList;
  
} catch (e) {
  return []; // Return an empty list if there is an error
  // return Future.error('Failed to load news: $e');
}
    // The best solution is to be dynamic
    // You can use List<Map<String, dynamic>> articles = jasonData['articles'] as List<Map<String,dynamic>> if you want to be more specific
    // for (var article in articles) {
    //   print(article); // Printing the title of each article
    // }
  }
}




// The first way to convert the map articles to a list of article model by using the default constructor

// List<ArticleModel> articlesList = [];
// for (var article in articles) {
//     // You can use the ArticleModel class to create a list of articles
//     articlesList.add(
//       ArticleModel(
//         image: article['urlToImage'],
//         title: article['title'],
//         subTitle: article['description'],
//       ),
//     );
//   }













