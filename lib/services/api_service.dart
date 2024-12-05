import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noticias/models/article.dart';

class ApiService {
  Future<List<Article>?> getNewsApiArticles(String params) async {
    var client = http.Client();
    var apiKey = "3aa4408bc46347f182285eeabc56592d";
    var uri = Uri.parse(
        'https://newsapi.org/v2/everything?apiKey=$apiKey&language=pt&q=$params');

    var news = await client.get(uri);

    if (news.statusCode == 200) {
      String cleanedBody = news.body.trim();

      final jsonData = jsonDecode(cleanedBody);

      if (jsonData.containsKey('articles')) {
        return List<Article>.from(
          jsonData['articles'].map((x) => Article.fromNewsApi(x)),
        );
      } else {
        log("A chave 'articles' não foi encontrada na resposta JSON.");
        return null; // Retorna uma lista vazia em caso de erro
      }

      // return List<Article>.from(json
      //     .decode(news.body)['articles']
      //     .map((x) => Article.fromNewsApi(x)));
    } else {
      log("Erro na resposta da API: ${news.statusCode}");
    }
    return null;
  }

  Future<List<Article>?> getNewsDataArticles(String params) async {
    var client = http.Client();
    var apiKey = "pub_60287dd7062d00d505525d71f4962b293f9b4";
    var uri = Uri.parse(
        'https://newsdata.io/api/1/latest?apikey=$apiKey&language=pt&qInMeta=$params');

    var news = await client.get(uri);

    if (news.statusCode == 200) {
      String cleanedBody = news.body.trim();

      final decodedNews = jsonDecode(cleanedBody);

      if (decodedNews['results'] != null) {
        return List<Article>.from(
            decodedNews['results'].map((x) => Article.fromNewsData(x)));
      } else {
        log("A chave 'results' não foi encontrada no JSON.");
      }
    } else {
      log("Erro na resposta da API: ${news.statusCode}");
    }
    return [];
  }
}
