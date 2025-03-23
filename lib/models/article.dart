class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String author;
  final String source;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.author,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? 'No content available',
      author: json['author'] ?? 'Unknown',
      source: json['source']['name'] ?? 'Unknown',
    );
  }
}