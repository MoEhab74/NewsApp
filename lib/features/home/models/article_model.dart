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

  // Prototype Pattern: Clone method
  
  /// Creates a copy of this article
  ArticleModel clone() {
    return ArticleModel(
      image: image,
      title: title,
      subTitle: subTitle,
      url: url,
    );
  }
  
  /// Creates a copy with modified fields
  /// Use this to create variations of an article
  ArticleModel copyWith({
    String? image,
    String? title,
    String? subTitle,
    String? url,
  }) {
    return ArticleModel(
      image: image ?? this.image,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      url: url ?? this.url,
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

  
