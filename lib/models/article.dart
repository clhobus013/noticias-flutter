import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:noticias/models/source.dart';

class Article {
  final String id;
  final Source source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  bool isRead;

  Article(
      {required this.id,
      required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content,
      required this.isRead});

  factory Article.fromNewsApi(Map<String, dynamic> json) => Article(
      id: sha256
          .convert(utf8.encode(json['title'] ?? '' + json['publishedAt'] ?? ''))
          .toString(),
      source: Source.fromJson(json['source'] ?? ''),
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
      isRead: false);

  factory Article.fromNewsData(Map<String, dynamic> json) {
    return Article(
        id: sha256
            .convert(utf8.encode(json['title'] ?? '' + json['pubDate'] ?? ''))
            .toString(),
        source: Source(
            id: json['source_id'] ?? '', name: json['source_name'] ?? ''),
        author: '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        url: json['link'] ?? '',
        urlToImage: json['image_url'] ?? '',
        publishedAt: json['pubDate'] ?? '',
        content: '',
        isRead: false);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'title': title,
      'author': author,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'isRead': isRead
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
