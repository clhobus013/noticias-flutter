import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:noticias/app_global.dart';
import 'package:noticias/list_articles.dart';
import 'package:noticias/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  var localNotification = FlutterLocalNotificationsPlugin();

  Future<String> _getSelectedSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('notification_sound') ?? '';
  }

  Future<bool> _getHighPriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('set_high_priority') ?? true;
  }

  Future<bool> _getShowSuccessNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('set_success_notification') ?? true;
  }

  Future<bool> _getShowErrorNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('set_error_notification') ?? true;
  }

  Future<void> configureLocalNotification() async {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const AndroidInitializationSettings cfgAnfroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        const InitializationSettings(android: cfgAnfroid);

    await localNotification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onReceiveNotification);
  }

  void onReceiveNotification(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload != null) {
      dev.log(payload);

      var params = payload.split("||||");
      String keyword = params[0];
      String stringArticles = params[1];

      Logger().i('Payload da notificacao: $payload');

      List<Article> articles = (jsonDecode(stringArticles) as List)
          .map((articleDynamic) {
            Article article = Article.fromNewsApi(articleDynamic);
            markAsRead(article.id);
            return article;
          })
          .toList()
          .cast<Article>();

      Navigator.push(
          AppGlobal.navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) =>
                  ListArticles(keyword: keyword, articles: articles)));
    } else {
      Logger().i('funcaoRespostaNotificacao');
    }
  }

  Future<NotificationDetails> getNotificationDetails(
      String channelId, String channelName) async {
    String selectedSound = await _getSelectedSound();
    bool highPriority = await _getHighPriority();

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            '$channelId${Random().nextInt(10000)}', channelName,
            sound: RawResourceAndroidNotificationSound(selectedSound),
            importance: Importance.max,
            priority: highPriority ? Priority.high : Priority.low);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    return notificationDetails;
  }

  void showNotification(List<Article> articles, String keyword) async {
    NotificationDetails notificationDetails = await getNotificationDetails(
        'canalAgoraId', 'Notificações novas notícias');

    await localNotification.show(
        0, 'Nova notícia!', 'palavra-chave: $keyword', notificationDetails,
        payload:
            '$keyword||||${jsonEncode(articles.map((article) => article.toJson()).toList())}');
  }

  void showSyncNotification() async {
    bool showNotification = await _getShowSuccessNotification();

    if (showNotification) {
      NotificationDetails notificationDetails = await getNotificationDetails(
          'canalSync', 'Notificação sincronização');

      await localNotification.show(
          0, 'Notícias sincronizadas com sucesso!', '', notificationDetails,
          payload: null);
    }
  }

  void showErrorNotification() async {
    bool showNotification = await _getShowErrorNotification();

    if (showNotification) {
      NotificationDetails notificationDetails =
          await getNotificationDetails('canalError', 'Erro sincronização');

      await localNotification.show(
          0,
          'Não foi possível sincronizar as notícias',
          'Verifique seu acesso a internet',
          notificationDetails,
          payload: null);
    }
  }

  Future<void> markAsRead(String newsId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(newsId, true); // Marca como lida
  }
}
