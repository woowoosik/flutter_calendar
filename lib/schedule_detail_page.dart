import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/fcm/fcm_controller.dart';
import 'package:schedule_calendar/google_map/google_map.dart';
import 'package:schedule_calendar/google_map/google_map_address.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:schedule_calendar/schedule_page_widget/add_map_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/date_button_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/end_time_picker_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/fcm_alarm_widget.dart';
import 'package:schedule_calendar/schedule_page_widget/start_time_picker_widget.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ScheduleDetailPage extends StatefulWidget {
  var schedule;

  late var provider;
  var startTime = TimeOfDay.fromDateTime(DateTime.now());
  var endTime = TimeOfDay.fromDateTime(DateTime.now());

  var alarmChecked = false;
  var alarmDate = DateTime.now().add(Duration(days: 1));
  var alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  final contentController = TextEditingController();

  var mapChecked = false;
  var mapData = GoogleMapCheck(
    isChecked: false,
    googleMapData: null,
  );

  ScheduleDetailPage({super.key, required this.schedule});

  @override
  State<StatefulWidget> createState() {
    return _ScheduleDetailPage();
  }
}

class _ScheduleDetailPage extends State<ScheduleDetailPage> {
  var root = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    widget.startTime = TimeOfDay(
        hour: int.parse(widget.schedule.startTime
            .toString()
            .padLeft(4, '0')
            .substring(0, 2)),
        minute: int.parse(widget.schedule.startTime
            .toString()
            .padLeft(4, '0')
            .substring(2, 4)));
    widget.endTime = TimeOfDay(
        hour: int.parse(
            widget.schedule.endTime.toString().padLeft(4, '0').substring(0, 2)),
        minute: int.parse(widget.schedule.endTime
            .toString()
            .padLeft(4, '0')
            .substring(2, 4)));

    widget.alarmChecked = widget.schedule.alarm.isChecked;
    if (widget.schedule.alarm.isChecked) {
      widget.alarmDate = DateTime(
        int.parse(widget.schedule.alarm.alarmData.alarmDate
            .toString()
            .substring(0, 4)),
        int.parse(widget.schedule.alarm.alarmData.alarmDate
            .toString()
            .substring(4, 6)),
        int.parse(widget.schedule.alarm.alarmData.alarmDate
            .toString()
            .substring(6, 8)),
      );
      widget.alarmTime = TimeOfDay(
          hour: int.parse(widget.schedule.alarm.alarmData.alarmTime
              .toString()
              .padLeft(4, '0')
              .substring(0, 2)),
          minute: int.parse(widget.schedule.alarm.alarmData.alarmTime
              .toString()
              .padLeft(4, '0')
              .substring(2, 4)));
    }

    widget.contentController.text = widget.schedule.content;

    widget.mapChecked = widget.schedule.googleMapCheck.isChecked;
    if (widget.schedule.googleMapCheck.isChecked) {
      widget.mapData = widget.schedule.googleMapCheck;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.provider = Provider.of<CalendarProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(
                children: [
                  DateButtonWidget(
                    btnName: '수정',
                    date: widget.schedule.date,
                    callback: () {
                      onSavedPressed(context);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StartTimePickerWidget(
                    startTime: widget.startTime,
                    callback: (value) {
                      widget.startTime = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  EndTimePickerWidget(
                    endTime: widget.endTime,
                    callback: (value) {
                      widget.endTime = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (Platform.isAndroid) ...[
                    FcmAlarmWidget(
                        alarmChecked: widget.alarmChecked,
                        alarmDate: widget.alarmDate,
                        alarmTime: widget.alarmTime,
                        alarmCheckedCallback: (value) {
                          widget.alarmChecked = value;
                        },
                        callback: (date, time) {
                          widget.alarmDate = date;
                          widget.alarmTime = time;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                            controller: widget.contentController,
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
                    mapData: widget.mapData,
                    callback: (map) {
                      widget.mapData = map;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  void onSavedPressed(BuildContext context) async {
    if (!widget.alarmChecked ||
        DateTime(
                widget.alarmDate.year,
                widget.alarmDate.month,
                widget.alarmDate.day,
                widget.alarmTime.hour,
                widget.alarmTime.minute)
            .isAfter(DateTime.now())) {
      var notificationId =
          ("${Random().nextInt(9999)}${widget.alarmDate.year}${widget.alarmDate.month}${widget.alarmDate.day}${widget.alarmTime.hour}${widget.alarmTime.minute}")
              .hashCode;
      // var notificationId = Uuid().v4().hashCode;
      if (!isCompare(widget.startTime, widget.endTime) ||
          !isSame(widget.startTime, widget.endTime)) {
        showToast('시작 시간과 종료 시간을 잘 적어주세요 (0시~24시)');
      } else if (widget.contentController.text == null ||
          widget.contentController.text == "") {
        showToast("내용을 적어주세요.");
      } else {
        var event = widget.provider.events;

        var start = int.parse(
            '${widget.startTime!.hour.toString().padLeft(2, '0')}${widget.startTime.minute.toString().padLeft(2, '0')}');
        var end = int.parse(
            '${widget.endTime!.hour.toString().padLeft(2, '0')}${widget.endTime.minute.toString().padLeft(2, '0')}');

        var date = DateTime.utc(widget.schedule.date.year,
            widget.schedule.date.month, widget.schedule.date.day);

        final schedule = ScheduleModel(
          id: widget.schedule.id,
          content: widget.contentController.text!,
          date: widget.schedule.date,
          startTime: start,
          endTime: end,
          googleMapCheck: widget.mapData,
          alarm: Alarm(
            isChecked: widget.alarmChecked,
            alarmData: !widget.alarmChecked
                ? null
                : AlarmData(
                    id: notificationId,
                    alarmDate: int.parse(
                        '${widget.alarmDate!.year.toString().padLeft(4, '0')}${widget.alarmDate.month.toString().padLeft(2, '0')}${widget.alarmDate.day.toString().padLeft(2, '0')}'),
                    alarmTime: int.parse(
                        '${widget.alarmTime!.hour.toString().padLeft(2, '0')}${widget.alarmTime.minute.toString().padLeft(2, '0')}'),
                  ),
          ),
        );

        if (event[date] == null || event[date].isEmpty) {
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
              print("onSavedPressed else ${i}  ${event[date].length - 1}");
              if (i == length - 1) {
                await FirebaseFirestore.instance
                    .collection('schedule')
                    .doc(root)
                    .collection(root)
                    .doc(widget.schedule.id)
                    .update(schedule.toJson())
                    .then((value) async {
                  var s = FCMController();
                  var token = await FirebaseMessaging.instance.getToken();

                  if (widget.alarmChecked) {
                    s.sendMessage(
                      id: notificationId,
                      userToken: token,
                      title: widget.contentController.text,
                      body: '',
                      timeZone: DateTime(
                          widget.alarmDate.year,
                          widget.alarmDate.month,
                          widget.alarmDate.day,
                          widget.alarmTime.hour,
                          widget.alarmTime.minute),
                      delete: false,
                    );
                  }

                  // 전 알림 지우기
                  if (widget.schedule.alarm.isChecked) {
                    s.sendMessage(
                      id: widget.schedule.alarm.alarmData.id,
                      userToken: token,
                      title: '삭제',
                      body: '',
                      timeZone: DateTime(
                          widget.alarmDate.year,
                          widget.alarmDate.month,
                          widget.alarmDate.day,
                          widget.alarmTime.hour,
                          widget.alarmTime.minute),
                      delete: true,
                    );
                  }

                  await widget.provider.removeEvent(date, widget.schedule.id);
                  await widget.provider?.addEvent(date, schedule);
                  Navigator.of(context).pop();
                });
              }
            }
          }
        }
      }
    } else {
      showToast("알람시간을 현재시간보다 높게 조정해주세요");
    }
  }
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_SHORT);
}
