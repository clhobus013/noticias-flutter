import 'package:flutter/material.dart';
import 'package:noticias/app_global.dart';
import 'package:noticias/article_details.dart';
import 'package:noticias/models/article.dart';

class ArticlePreviewWidget extends StatefulWidget {
  final Article article;

  const ArticlePreviewWidget({super.key, required this.article});

  @override
  State<ArticlePreviewWidget> createState() => _ArticlePreviewWidgetState();
}

class _ArticlePreviewWidgetState extends State<ArticlePreviewWidget> {
  late Article _article;

  @override
  void initState() {
    super.initState();

    _article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
              AppGlobal.navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) => ArticleDetails(article: _article)))
        },
        child: Row(
          children: [
            renderImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      _article.title ?? 'Título não encontrado',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _article.description ?? 'Descrição não encontrada',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(_article.author != ''
                        ? 'Autor: ${_article.author}'
                        : 'Autor não encontrado')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        _article.urlToImage != '' && _article.urlToImage != null
            ? _article.urlToImage!
            : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png?20210521171500',
        width: 120,
      ),
    );
  }
}
