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
      title: json['title'] ?? 'No title available',
      subTitle: json['description'],
      url: json['url'] ?? ''
    );
  }

  /// Convert ArticleModel to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'urlToImage': image,
      'title': title,
      'description': subTitle,
      'url': url,
    };
  }

  
}

// class Source {
//   final String? name;
//   final String? id;
//   Source({
//     required this.name,
//     required this.id,
//   });

  
