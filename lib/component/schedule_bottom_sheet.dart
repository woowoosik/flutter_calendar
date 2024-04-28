import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_card.dart';
import 'package:schedule_calendar/fcm/fcm_controller.dart';
import 'package:schedule_calendar/google_map/google_map.dart';
import 'package:schedule_calendar/google_map/google_map_address.dart';
import 'package:schedule_calendar/google_map/google_map_model.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:schedule_calendar/schedule_page_widget/add_map_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/date_button_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/end_time_picker_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/fcm_alarm_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/start_time_picker_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:schedule_calendar/google_map/google_map_address.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜 상위 위젯에서 입력받기

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScheduleBottomSheet();
  }
}

class _ScheduleBottomSheet extends State<ScheduleBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey();

  var root = FirebaseAuth.instance.currentUser!.uid;

  late var provider;
  var startTime = TimeOfDay.fromDateTime(DateTime.now());
  var endTime = TimeOfDay.fromDateTime(DateTime.now());

  var alarmChecked = false;
  var alarmDate = DateTime.now().add(Duration(days: 1));
  var alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  var mapData = GoogleMapCheck(
    isChecked: false,
    googleMapData: null,
  );

  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CalendarProvider>(context);

    return Scaffold(
      body: Form(
        // 텍스트 필드를 한 번에 관리할 수 있는 폼
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  children: [
                    DateButtonWidget(
                      btnName: '저장',
                      date: widget.selectedDate,
                      callback: () {
                        onSavedPressed(context);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StartTimePickerWidget(
                      startTime: startTime,
                      callback: (value) {
                        print("detail start time picker 전 : ${startTime}");
                        startTime = value;
                        print("detail start time picker 후 : ${startTime}");
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    EndTimePickerWidget(
                      endTime: endTime,
                      callback: (value) {
                        endTime = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (Platform.isAndroid) ...[
                      FcmAlarmWidget(
                          alarmChecked: alarmChecked,
                          alarmDate: alarmDate,
                          alarmTime: alarmTime,
                          alarmCheckedCallback: (value) {
                            alarmChecked = value;
                          },
                          callback: (date, time) {
                            alarmDate = date;
                            alarmTime = time;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Stack(
                        children: [
                          const Positioned(
                            left: 0,
                            top: 12,
                            child: Icon(
                              Icons.notes_rounded,
                              size: 30.0,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(33.0, 0.0, 0.0, 0.0),
                            child: TextField(
                              controller: contentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '내용을 입력해주세요.',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AddMapWidget(
                      mapData: mapData,
                      callback: (map) {
                        print("map call back!! ${map.isChecked}");
                        print("map call back!! ${map}");
                        mapData = map;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavedPressed(BuildContext context) async {
    if (!alarmChecked ||
        DateTime(alarmDate.year, alarmDate.month, alarmDate.day, alarmTime.hour,
                alarmTime.minute)
            .isAfter(DateTime.now())) {
      var notificationId =
          ("${Random().nextInt(9999)}${alarmDate.year}${alarmDate.month}${alarmDate.day}${alarmTime.hour}${alarmTime.minute}")
              .hashCode;
      // var notificationId = Uuid().v4().hashCode;
      if (!isCompare(startTime, endTime) || !isSame(startTime, endTime)) {
        showToast('시작 시간과 종료 시간을 잘 적어주세요 (0시~24시)');
      } else if (contentController.text == null ||
          contentController.text == "") {
        showToast("내용을 적어주세요.");
      } else {
        var event = provider.events;

        var start = int.parse(
            '${startTime!.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}');
        var end = int.parse(
            '${endTime!.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}');

        var date = DateTime.utc(widget.selectedDate.year,
            widget.selectedDate.month, widget.selectedDate.day);

        final schedule = ScheduleModel(
          id: Uuid().v4(),
          content: contentController.text!,
          date: widget.selectedDate,
          startTime: start,
          endTime: end,
          googleMapCheck: mapData,
          alarm: Alarm(
            isChecked: alarmChecked,
            alarmData: !alarmChecked
                ? null
                : AlarmData(
                    id: notificationId,
                    alarmDate: int.parse(
                        '${alarmDate!.year.toString().padLeft(4, '0')}${alarmDate.month.toString().padLeft(2, '0')}${alarmDate.day.toString().padLeft(2, '0')}'),
                    alarmTime: int.parse(
                        '${alarmTime!.hour.toString().padLeft(2, '0')}${alarmTime.minute.toString().padLeft(2, '0')}'),
                  ),
          ),
        );

        if (event[date] == null || event[date].isEmpty) {
          await FirebaseFirestore.instance
              .collection("schedule")
              .doc(root)
              .collection(root)
              .doc(schedule.id)
              .set(schedule.toJson())
              .then((value) async {
            print("${date}  ${schedule}");
            provider?.addEvent(date, schedule);

            if (Platform.isAndroid) {
              var s = FCMController();
              var token = await FirebaseMessaging.instance.getToken();

              if (alarmChecked) {
                s.sendMessage(
                  id: notificationId,
                  userToken: token,
                  title: contentController.text,
                  body: '',
                  timeZone: DateTime(
                    alarmDate.year,
                    alarmDate.month,
                    alarmDate.day,
                    alarmTime.hour,
                    alarmTime.minute,
                  ),
                  delete: false,
                );
              }
            }

            Navigator.of(context).pop();
          });
        } else {
          var length = event[date].length;
          for (var i = 0; i < length; i++) {
            var data = event[date][i] as ScheduleModel;

            if (data.startTime < start && start < data.endTime) {
              showToast('저장하려는 시간에 스케줄이 있어요!');
              break;
            } else if (data.startTime < end && end < data.endTime) {
              showToast('저장하려는 시간에 스케줄이 있어요!');
              break;
            } else {
              if (i == length - 1) {
                await FirebaseFirestore.instance
                    .collection('schedule')
                    .doc(root)
                    .collection(root)
                    .doc(schedule.id)
                    .set(schedule.toJson())
                    .then((value) async {
                  provider?.addEvent(date, schedule);

                  if (Platform.isAndroid) {
                    var s = FCMController();
                    var token = await FirebaseMessaging.instance.getToken();

                    if (alarmChecked) {
                      s.sendMessage(
                        id: notificationId,
                        userToken: token,
                        title: contentController.text,
                        body: '',
                        timeZone: DateTime(alarmDate.year, alarmDate.month,
                            alarmDate.day, alarmTime.hour, alarmTime.minute),
                        delete: false,
                      );
                    }
                  }

                  Navigator.of(context).pop();
                });
                // 일정 생성 후 화면 뒤로 가기
              }
            }
          }
        }
      }
    } else {
      showToast("알람시간을 현재시간보다 높게 조정해주세요");
    }
  }

  bool isSame(TimeOfDay startTime, TimeOfDay endTime) {
    var startMinute = startTime.hour * 60 + startTime.minute;
    var endMinute = endTime.hour * 60 + endTime.minute;

    if (startMinute < endMinute) {
      return true;
    } else {
      return false;
    }
  }

  bool isCompare(TimeOfDay startTime, TimeOfDay endTime) {
    var startMinute = startTime.hour * 60 + startTime.minute;
    var endMinute = endTime.hour * 60 + endTime.minute;

    if (0 <= startMinute && startMinute < 1440) {
      if (0 <= endMinute && endMinute < 1440) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_SHORT);
}
