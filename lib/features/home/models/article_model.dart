class ArticleModel {
  final String? image;
  final String title;
  final String? subTitle;
  final String url;
  // final Source source;
  ArticleModel({
    // required this.source,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.url,
  });

  factory ArticleModel.fromJson({json}){
    return ArticleModel(
      image: json['urlToImage'],
      title: json['title'],
      subTitle: json['description'],
      url: json['url'] 
    );
  }

  
}

// class Source {
//   final String? name;
//   final String? id;
//   Source({
//     required this.name,
//     required this.id,
//   });

  
