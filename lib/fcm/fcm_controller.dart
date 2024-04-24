import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class FCMController {
  final String _serverKey = "AAAAn575CSw:APA91bGIkdZdWwr_dTfGPnnA_nMs5nNQ-Vo2cfPrApPFA1BU11eNs626ztnX0SKyEsUwvHY2S26Ml9F1iF9lPDloq1Kl2REVFHxx3AA5XAKWr3XQT0lumI5krC8f3uIeUXquFE1BM5d4";

  Future<void> sendMessage({
    required int id,
    required String? userToken,
    required String title,
    required String body,
    required DateTime timeZone,
    required bool delete,
  }) async {

    http.Response response;

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,

    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
          body: jsonEncode({
            /*'notification': {
              'title': title,
              'body': body,
              'sound': 'false'
            },*/
            'ttl': '600000s',
            "content_available": true,
            'data': {
              'title': title,
              'body': body,
              'id': id,
              'time_year': timeZone.year,
              'time_month': timeZone.month,
              'time_day': timeZone.day,
              'time_hour': timeZone.hour,
              'time_minute': timeZone.minute,
              'delete_alarm': delete,
            },
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            'to': userToken,

            // 'registration_ids': tokenList
          }));
    } catch (e) {
      print('error $e');
    }
  }
}