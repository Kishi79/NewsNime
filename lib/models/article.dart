class Article {
  final String id;
  final String title;
  final String category;
  final String publishedAt;
  final String readTime;
  final String imageUrl;
  final bool isTrending;
  final List<String> tags;
  final String content;
  final Author author;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.readTime,
    required this.imageUrl,
    required this.isTrending,
    required this.tags,
    required this.content,
    required this.author,
  });

  // Ini adalah "factory constructor" untuk membuat objek Article dari data JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      publishedAt: json['publishedAt'],
      readTime: json['readTime'],
      imageUrl: json['imageUrl'],
      isTrending: json['isTrending'],
      tags: List<String>.from(json['tags']),
      content: json['content'],
      author: Author.fromJson(json['author']),
    );
  }
}

class Author {
  final String name;
  final String title;
  final String avatar;

  Author({required this.name, required this.title, required this.avatar});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      title: json['title'],
      avatar: json['avatar'],
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      hasMore: json['hasMore'],
    );
  }
}