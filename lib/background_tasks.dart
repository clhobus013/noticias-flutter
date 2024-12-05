import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:noticias/services/api_service.dart';
import 'package:noticias/models/article.dart';
import 'package:noticias/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void backgroundCallback(String task) async {
  var log = Logger();
  log.i('callbackDispatcher: INICIANDO....');

  // Workmanager().executeTask((task, inputData) async {

  log.i(
      "Tarefa com atraso de 1 minuto para iniciar depois que soliciou e com recorrência (15 min): EXECUTOU");

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listKeywords = prefs.getStringList('keywords') ?? [];

    List<Article> apiArticles = [];
    List<Article> dataArticles = [];

    NotificationService().showSyncNotification();

    for (var keyword in listKeywords) {
      apiArticles = await ApiService().getNewsApiArticles(keyword) ?? [];

      log.i('Api articles ${apiArticles.length}');

      dataArticles = await ApiService().getNewsDataArticles(keyword) ?? [];

      log.i('data articles ${dataArticles.length}');

      apiArticles = apiArticles + dataArticles;

      log.i('Api total ${apiArticles.length}');

      if (apiArticles.length > 0) {
        checkNewsAndNotify(apiArticles, keyword);
      }
    }

    log.i("Artigos obtidos: ${apiArticles.length + dataArticles.length}");
  } catch (e) {
    log.e('Erro ao buscar artigos: $e');
    NotificationService().showErrorNotification();
  }
}

Future<void> checkNewsAndNotify(
    List<Article> articlesList, String keyword) async {
  List<Article> articlesToNotify = [];

  for (var article in articlesList) {
    bool isRead = await isNotificationRead(article.id);

    if (!isRead) {
      articlesToNotify.add(article);
    }
  }

  NotificationService().showNotification(articlesToNotify, keyword);
}

Future<bool> isNotificationRead(String generatedId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(generatedId) ?? false;
}

class BackgroundTasks extends StatefulWidget {
  const BackgroundTasks({super.key});

  @override
  State<BackgroundTasks> createState() => _BackgroundTasksState();
}

class _BackgroundTasksState extends State<BackgroundTasks> {
  @override
  void initState() {
    super.initState();

    Workmanager().initialize(
      backgroundCallback,
      isInDebugMode: true,
    );

    Workmanager().registerPeriodicTask("searchNews", "searchNews",
        initialDelay: const Duration(seconds: 15),
        frequency: const Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.append);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
