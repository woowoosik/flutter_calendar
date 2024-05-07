import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/calendar_week.dart';
import 'package:schedule_calendar/fcm/forground_notification.dart';
import 'package:schedule_calendar/login/login_page.dart';
import 'package:schedule_calendar/login/text_field_widget.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:schedule_calendar/schedule_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/main_calendar.dart';
import 'package:schedule_calendar/component/schedule_card.dart';
import 'package:schedule_calendar/component/today_banner.dart';
import 'model/schedule_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late var provider;

  Logger logger = Logger();

  var root = FirebaseAuth.instance.currentUser!.uid;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  var visible = true;

  var weekDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  var dateData;

  Map<DateTime, List<dynamic>> events = {};


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CalendarProvider>(context);
    logger.d("HOME PAGE");

    const List<String> list = <String>['로그아웃', '탈퇴하기'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: getEventMarker(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.small(
              shape: const CircleBorder(),
              backgroundColor: PRIMARY_COLOR,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 1),
                          end: const Offset(0.0, 0.0),
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ScheduleBottomSheet(
                          selectedDate: selectedDate,
                        ),
                    fullscreenDialog: false,
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBar(
              title: const Text('Schedule Calendar'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: DropdownButton(
                      underline: const SizedBox.shrink(),
                      icon: const Icon(Icons.menu),
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? str) async {
                        if (str == list[0]) {
                          await FirebaseAuth.instance.signOut();
                          moveLoginPage();
                        } else {
                          userDelete();
                        }
                      }),
                ),
              ],
            ),
            body: Column(
              children: [
                MainCalendar(
                  getEventsForDay: getEventsForDay,
                  selectedDate: selectedDate,
                  //   날짜 전달
                  onDaySelected: onDaySelected,
                  //  typedef
                  onFormatChanged: onFormatChanged,
                  onPageChanged: onPageChanged,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Visibility(
                        visible: visible,
                        child: Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 8.0),
                              TodayBanner(
                                selectedDate: selectedDate,
                                count: provider.events[selectedDate] == null
                                    ? 0
                                    : provider.events[selectedDate].length,
                                weekDate: weekDate,
                              ),
                              SizedBox(height: 8.0),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: provider.events[selectedDate] == null
                                      ? 0
                                      : provider.events[selectedDate].length,
                                  itemBuilder: (context, index) {
                                    var events = provider.events[selectedDate]
                                      ..sort((a, b) {
                                        var s = a.startTime as int;
                                        var e = b.startTime as int;
                                        return s.compareTo(e);
                                      });

                                    final schedule = events[index];

                                    return Dismissible(
                                      key: ObjectKey(schedule.id),
                                      direction: DismissDirection.startToEnd,
                                      onDismissed: (DismissDirection direction) {
                                        var k = DateTime.utc(schedule.date.year,
                                            schedule.date.month, schedule.date.day);

                                        provider.removeEvent(k, schedule.id);

                                        FirebaseFirestore.instance
                                            .collection('schedule')
                                            .doc(root)
                                            .collection(root)
                                            .doc(schedule.id)
                                            .delete();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, left: 8.0, right: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(1, 0),
                                                      end: const Offset(0, 0),
                                                    ).animate(
                                                      CurvedAnimation(
                                                        parent: animation,
                                                        curve: Curves.easeInOutCubic,
                                                      ),
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                                pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                    ScheduleDetailPage(
                                                        schedule: schedule),
                                              ),
                                            );
                                          },
                                          child: ScheduleCard(
                                            schedule: schedule,
                                            startTime: schedule.startTime,
                                            endTime: schedule.endTime,
                                            content: schedule.content,
                                            index: index,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !visible,
                        //child: Text("${weekDate}"),
                        child: CalendarWeek(weekDate: weekDate),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  }

  Future<bool> emailCheck() async {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    var result = false;

    await showDialog(
      context: context,
      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return AlertDialog(
          title: const Text("이메일, 비밀번호 확인"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //textWidget('이메일을 입력해주세요.', const Icon(Icons.email_outlined), emailController),
              TextFieldWidget(
                password: false,
                hint: '이메일을 입력해주세요.',
                icon: const Icon(Icons.email_outlined),
                controller: emailController,
                callback: () async {
                  result = await deleteEmail(
                      emailController.text, passwordController.text);
                },
              ),
              SizedBox(
                height: 5,
              ),
              //textWidget('비밀번호를 입력해주세요.', const Icon(Icons.lock_outline_rounded), passwordController),
              TextFieldWidget(
                password: true,
                hint: '비밀번호를 입력해주세요.',
                icon: const Icon(Icons.lock_outline_rounded),
                controller: passwordController,
                callback: () async {
                  result = await deleteEmail(
                      emailController.text, passwordController.text);
                },
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: PRIMARY_COLOR,
                ),
                onPressed: () async {
                  result = await deleteEmail(
                      emailController.text, passwordController.text);
                },
                child: const Text(
                  "확인",
                  style: TextStyle(
                    color: LOGIN_TEXT_COLOR,
                  ),
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: LIGHT_PRIMARY_COLOR,
                ),
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop(); //창 닫기
                },
                child: const Text(
                  "취소",
                  style: TextStyle(
                    color: LOGIN_TEXT_COLOR,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );

    return result;
  }

  Future<bool> deleteEmail(String email, String password) async {
    var result = await userRecertification(email, password);
    if (result) {
      result = true;
      Navigator.of(context).pop(); //창 닫기
    } else {
      Fluttertoast.showToast(
          msg: '이메일, 비밀번호가 틀렸습니다.',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }

    return result;
  }

  void userDelete() async {
    final user = FirebaseAuth.instance.currentUser;

    const CircularProgressIndicator();

    if (await emailCheck()) {
      await user?.delete().then((value) => {
            FirebaseFirestore.instance
                .collection('schedule')
                .doc(root)
                .collection(root)
                .get()
                .then((value) {
              for (var i in value.docs) {
                FirebaseFirestore.instance
                    .collection('schedule')
                    .doc(root)
                    .collection(root)
                    .doc(i.id)
                    .delete();
              }
            })
          });

      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(root)
          .delete()
          .then((value) => moveLoginPage());
    }
  }

  dynamic moveLoginPage() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        ),
        (route) => false);
  }

  Future<bool> userRecertification(String str, String password) async {
    var bool = false;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: str, password: password)
          .then((value) => {
                if (root == value.user?.uid) {bool = true}
              });
    } catch (e) {
      return false;
    }

    return bool;
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
  ) {
    // 날짜 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
      weekDate = focusedDate;
    });
  }

  void onFormatChanged(
      DateTime selectedDate, DateTime focusedDate, dynamic format) {
    logger.d('onFormatChanged:  ${selectedDate}  ${focusedDate}  ${format}');
    setState(() {
      visible = format == CalendarFormat.week ? false : true;
    });
  }

  void onPageChanged(
      DateTime selectedDate, DateTime focusedDate, DateTime focusedDay) async {
    setState(() {
      logger.d("onPageChanged: ${selectedDate}  ${focusedDate}  ${focusedDay} ");
      weekDate = focusedDay;
    });
  }

  List<dynamic> getEventsForDay(DateTime day) {
    return provider.events[day] ?? [];
  }

  Future<dynamic> getEventMarker() async {
    events = {};
    logger.d("uid : ${FirebaseAuth.instance.currentUser!.uid}");

    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(root)
        .collection(root)
        .get()
        .then(
      (querySnapshot) {
        var docs = querySnapshot.docs;

        for (var data in docs!) {
          var dateTimestamp = (data.data()['date'] as Timestamp).toDate();
          var date = DateTime.utc(
              dateTimestamp.year, dateTimestamp.month, dateTimestamp.day);
          var content = data.data()['content'];
          var startTime = data.data()['startTime'];
          var endTime = data.data()['endTime'];
          var id = data.data()['id'];
          var googleMapCheck = data.data()['googleMapCheck'];

          var alarm = data.data()['alarm'];

          if (events[date] == null) {
            events[date] = [];
          }

          var scheduleData = ScheduleModel(
            id: id,
            date: date,
            startTime: startTime,
            endTime: endTime,
            content: content,
            googleMapCheck: GoogleMapCheck.fromJson(json: googleMapCheck),
            alarm: Alarm.fromJson(json: alarm),
          );
          events[date]?.add(scheduleData);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    // setState(() {});
    Provider.of<CalendarProvider>(context, listen: false).getEvents(events);
    return events;
  }
}
