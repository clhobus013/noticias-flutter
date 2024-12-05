import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noticias/models/article.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;

  const ArticleDetails({super.key, required this.article});

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  late Article _article;

  @override
  void initState() {
    super.initState();
    _article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
          title: Text(_article.title!),
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
          children: [
            Image.network(_article.urlToImage != '' &&
                    _article.urlToImage != null
                ? _article.urlToImage!
                : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png?20210521171500'),
            Text(
              _article.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(_article.content ?? ''),
            Text(_article.description ?? '')
          ],
        ));
  }
}
