import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notify {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      TabController tabController) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializeSettings = InitializationSettings(
      android: androidInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializeSettings,
        onDidReceiveNotificationResponse: (response) {
      tabController.index = 1;
    });
  }

  static Future showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'unique_channel_id',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationInstance = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    Timer(const Duration(seconds: 3), () async {
      await flutterLocalNotificationsPlugin.show(
          0,
          'Atenção ao prazo!',
          'Você possui lembretes finalizando o prazo em breve.',
          notificationInstance);
    });
  }
}
