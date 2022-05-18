import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late AndroidNotificationChannel channel;
FirebaseMessaging messaging = FirebaseMessaging.instance;
late FlutterLocalNotificationsPlugin localNotificationsPlugin;

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  //BACKGROUND Notifications - iOS & Android
  print('Message: ${remoteMessage.messageId}');
  print('data ${remoteMessage.data}');
}

mixin FbNotifications {
  /// CALLED IN main function between ensureInitialized <-> runApp(widget);
  static Future<void> initNotifications() async {
    //Connect the previous created function with onBackgroundMessage to enable
    //receiving notification when app in Background.
    //Channel
    if (!kIsWeb) {
      var androiInit =
          AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
      var iosInit = IOSInitializationSettings();
      var initSetting =
          InitializationSettings(android: androiInit, iOS: iosInit);
      localNotificationsPlugin = FlutterLocalNotificationsPlugin();
      localNotificationsPlugin.initialize(initSetting);
      var androidDetails =
          AndroidNotificationDetails('1', 'channelName', 'channel Description');
      var iosDetails = IOSNotificationDetails();
      var generalNotificationDetails =
          NotificationDetails(android: androidDetails, iOS: iosDetails);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          localNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              generalNotificationDetails);
          print(notification.title);
          print(notification.body);
        }
      });
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      //event => NEW FCM TOKEN
      //if(userPref.isLoggedIn){
      // SEND IT TO SERVER SIDE (API)
      // }
    });
  }

//iOS Notification Permission
  Future<void> requestNotificationPermissions() async {
    print('requestNotificationPermissions');
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      // carPlay: false,
      // announcement: false,
      // provisional: false,
      // criticalAlert: false,
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('GRANT PERMISSION');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      print('Permission Denied');
    }
  }

//ANDROID
  void initializeForegroundNotificationForAndroid() {
    print('initializeForegroundNotificationForAndroid');
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message Received: ${message.messageId}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = notification?.android;
      if (notification != null && androidNotification != null) {
        localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

//GENERAL (Android & iOS)
  void manageNotificationAction() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _controlNotificationNavigation(message.data);
      print('manageNotificationAction : ${message.data}');
    });
  }

  void _controlNotificationNavigation(Map<String, dynamic> data) {
    print('data: $data');
    if (data['page'] != null) {
      switch (data['page']) {
        case 'products':
          var productId = data['id'];
          print('Product Id: $productId');
          break;

        case 'settings':
          print('Navigate to settings');
          break;

        case 'profile':
          print('Navigate to Profile');
          break;
      }
    }
  }
}
