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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();


  print("Handling a background message: ${message.messageId}");
}


// e9x-GZLIS2ev4_M9d1QFou:APA91bH5STmJQRpMUw0yVKVB_1C9ktGFnJ8hYP5pW90OvMEhQhCPG20yYo-HJNC4Y0oyVjXRURXv4FYEEJ9Ri1xh-kkcbyc0bhM4jIbgRVJSrubpDYKKgRU0KhjuYNdVyTjVZMAzWp4D
void main() async {
  // 플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 프로젝트 설정 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // intl 패키지 초가화 (다국어화)
  await initializeDateFormatting();


 // _initLocalNotification();
  LocalNotification.initialize();

  requestNotificationPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
    if (message != null) {
      if (message.notification != null) {
        print('t ${message.notification!.title}');
        print('b ${message.notification!.body}');
        print('${message.data["click_action"]}');

      }

      LocalNotification.showNotification(message);

    }
  });


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: MyApp(),
    ),
  );

}


Future<void> requestNotificationPermission() async{

  String? _fcmToken = await FirebaseMessaging.instance.getToken();
  print('@---:  ${_fcmToken}');

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}




/*

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  var visible = true;

  var pageChangeFocusDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar'),
      ),
      body: Column(
        children: [

          MainCalendar(
            selectedDate: selectedDate,   //   날짜 전달
            onDaySelected: onDaySelected,   //  typedef
            onFormatChanged: onFormatChanged,
            onPageChanged: onPageChanged,
          ),

          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: visible,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8.0,),
                        TodayBanner(selectedDate: selectedDate, count: 0),
                        SizedBox(height: 8.0,),
                        ScheduleCard(startTime: 11, endTime: 21, content: '공부'),
                        ScheduleCard(startTime: 11, endTime: 21, content: '공부'),
                        ScheduleCard(startTime: 11, endTime: 21, content: '공부'),
                        ScheduleCard(startTime: 11, endTime: 21, content: '공부'),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !visible,
                  child: Text('${pageChangeFocusDay}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    print('onDaySelected  ${selectedDate}  ${focusedDate}');
    setState(() {
      this.selectedDate = selectedDate;
    });
  }


  void onFormatChanged(DateTime selectedDate, DateTime focusedDate, dynamic format){
    print('onFormatChanged  ${selectedDate}  ${focusedDate}  ${format}');
    setState(() {
      visible = format == CalendarFormat.week? false:true;
    });
  }

  */
/*void onFormatSelected(DateTime selectedDate, DateTime focusedDate, dynamic format){
    print('onListenFormat  ${selectedDate}  ${format}');
    setState(() {
      format == CalendarFormat.week? visible=0:visible=1;
    });
  }*//*


  void onPageChanged(DateTime selectedDate, DateTime focusedDate, DateTime focusedday){
    print(" onPageChanged ${selectedDate}  ${focusedDate}  ${focusedday} ");

    setState(() {
      pageChangeFocusDay = focusedday;
    });
  }


}

*/

