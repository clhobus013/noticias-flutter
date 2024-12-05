import 'package:flutter/material.dart';
import 'package:noticias/home.dart';
import 'package:noticias/services/notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().configureLocalNotification();

  runApp(const Home());
}
