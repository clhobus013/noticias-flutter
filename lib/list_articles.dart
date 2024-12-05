import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noticias/models/article.dart';
import 'package:noticias/widgets/article_preview_widget.dart';

class ListArticles extends StatefulWidget {
  final List<Article> articles;
  final String keyword;

  const ListArticles(
      {super.key, required this.articles, required this.keyword});

  @override
  State<ListArticles> createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {
  late List<Article> _articles;
  late String _keyword;

  @override
  void initState() {
    super.initState();
    _articles = widget.articles;
    _keyword = widget.keyword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
          title: const Text("Feed de Notícias"),
          leading: const Center(
            child: FaIcon(
              FontAwesomeIcons.shieldCat,
              size: 40,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              color: Colors.grey,
              height: 0.8,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.gear),
              tooltip: 'Configurações',
              onPressed: () {},
            ),
          ],
        ),
        // body: Parte2ComWorkmanager());
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '$_keyword:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Expanded(
                child: ListView(
              children: _articles
                  .map((article) => ArticlePreviewWidget(article: article))
                  .toList(),
            ))
          ],
        ));
  }
}
