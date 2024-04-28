import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule_calendar/firebase_options.dart';
import 'package:schedule_calendar/fcm/forground_notification.dart';
import 'package:schedule_calendar/login/login_page.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:schedule_calendar/main_calendar.dart';
import 'package:schedule_calendar/component/schedule_card.dart';
import 'package:schedule_calendar/component/today_banner.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // 세로 모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // 플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 프로젝트 설정 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // intl 패키지 초가화 (다국어화)
  await initializeDateFormatting();

  if (Platform.isAndroid) {
    LocalNotification.initialize();

    requestNotificationPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null) {
        if (message.notification != null) {
          print('${message.data["click_action"]}');
        }

        LocalNotification.showNotification(message);
      }
    });
  } else {
    print("##### ios 플랫폼 #####");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  String? _fcmToken = await FirebaseMessaging.instance.getToken();
  print('token :  ${_fcmToken}');

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
