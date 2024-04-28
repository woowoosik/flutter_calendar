import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
  FlutterLocalNotificationsPlugin();




  static void initialize() {
    final InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          print('onDidReceiveNotificationResponse Function');
          print(details.payload);
          print(details.payload != null);
        });
  }

  static void notificationRemove(int id){
    _notiPlugin.cancel(id);
  }

  static void showNotification(RemoteMessage message) {
    final NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'ch_id',
        'ch_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );


    var androidDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      '유니크한 알림 ID',
      '알림종류 설명',
      priority: Priority.high,
      importance: Importance.max,
      color: PRIMARY_COLOR,
    ));

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime ararm = tz.TZDateTime(
        tz.local,
        int.parse(message.data['time_year']),
        int.parse(message.data['time_month']),
        int.parse(message.data['time_day']),
        int.parse(message.data['time_hour']),
        int.parse(message.data['time_minute']),
    );

    tz.TZDateTime duration = now.add(const Duration(minutes: 1));

    tz.TZDateTime schedule = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));


    if(!bool.parse(message.data['delete_alarm'])){
      _notiPlugin.zonedSchedule(
        int.parse(message.data['id']),
        message.data['title'],
        message.data['body'],
        ararm,
        androidDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
      );
    }else{
      _notiPlugin.cancel(int.parse(message.data['id']));
    }


  }

}