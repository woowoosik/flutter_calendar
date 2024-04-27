import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/cutom_text_field.dart';
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
import 'package:schedule_calendar/utils.dart';
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

  var _isMapChecked = false;

/*
  var startTime;
  var endTime;*/
  //String? content;

  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CalendarProvider>(context);
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;


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
                // 패딩에 키보드 높이 추가해서 위젯 전반적으로 위로 올려주기
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
                      startTime:startTime,
                      callback: (value){
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

                    if(Platform.isAndroid)...[
                      FcmAlarmWidget(
                          alarmChecked: alarmChecked,
                          alarmDate: alarmDate,
                          alarmTime: alarmTime,
                          alarmCheckedCallback:(value){
                            alarmChecked = value;
                          },
                          callback: (date, time){
                            alarmDate = date;
                            alarmTime = time;
                          }
                      ),

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


                    /* Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              tz.initializeTimeZones();
                              tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 30.0,
                            ),

                          ),

                          Text(
                            "${widget.selectedDate.year}"
                                " - ${widget.selectedDate.month.toString().padLeft(2, '0')}"
                                " - ${widget.selectedDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: PRIMARY_COLOR,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            // 3 저장 버튼
                            onPressed: () async{
                              onSavedPressed(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                            ),
                            child: const Text(
                              '저장',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
*/

                  /*  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "시작시간",
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                              );
                              if (timeOfDay != null) {
                                setState(() {
                                  startTime = timeOfDay;
                                });
                              }
                            },
                            child: Text(
                              '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "종료시간",
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                              );
                              if (timeOfDay != null) {
                                setState(() {
                                  endTime = timeOfDay;
                                });
                              }
                            },
                            child: Text(
                              '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),*/
                    /*
                    if(Platform.isAndroid)...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                              Row(
                                children: [
                                  const Icon(
                                    Icons.alarm_on,
                                    size: 30.0,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),

                                  Visibility(
                                    visible: !_isChecked,
                                    child: const Text(
                                      "푸시알림",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isChecked,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final DateTime? dateTime = await showDatePicker(
                                                context: context,
                                                initialDate: alarmDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(3000));
                                            if (dateTime != null) {
                                              setState(() {
                                                alarmDate = dateTime;
                                              });
                                            }
                                          },
                                          child: Text(
                                            '${alarmDate.year}-${alarmDate.month.toString().padLeft(2, '0')}-${alarmDate.day.toString().padLeft(2, '0')}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final TimeOfDay? timeOfDay = await showTimePicker(
                                              context: context,
                                              initialTime: alarmTime,
                                            );
                                            if (timeOfDay != null) {
                                              setState(() {
                                                alarmTime = timeOfDay;
                                              });
                                            }
                                          },
                                          child: Text(
                                            '(${alarmTime.hour}:${alarmTime.minute.toString().padLeft(2, '0')})',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),



                                ],
                              ),

                              Row(
                                children: [
                                  Switch(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value;
                                      });
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),


                          ],
                        ),
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
*/

                /*
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "맵 추가하기",
                                style: TextStyle(fontSize: 25),
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              *//*Switch(
                                value: _isMapChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isMapChecked = value;


                                  });
                                },
                              ),
                              *//*
                              GestureDetector(
                                onTap: () async {
                                  print("지도 이동");
                                  if(await checkPermission()){
                                    print("지도 이동 2 ");
                                    mapData = await Navigator.push(context,
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
                                          pageBuilder: (context, animation, secondaryAnimation) {
                                            //var position = getCurrentLocation();
                                            return FutureBuilder(
                                                future: getCurrentLocation(),
                                                builder: (context, s ){
                                                  if(s.hasData){
                                                    print("@#@#@@@@#@@# ${s.data} ");
                                                    *//*mapData = GoogleMapData(
                                                    isChecked: false,
                                                    lat: 0.0,
                                                    lng: 0.0,
                                                    name: "",
                                                    formatted_address: "",
                                                  );*//*
                                                    return GoogleMapAddress(position: s.data, mapData: mapData);
                                                  }else{
                                                    return Scaffold(
                                                      body: Center(
                                                          child: CircularProgressIndicator()
                                                      ),
                                                    );
                                                  }
                                                }
                                            );
                                          }
                                      ),
                                    );
                                  }else{
                                    showToast('위치 서비스를 활성화 해주세요.');
                                  }

                                  print("map call back!! ${mapData.isChecked}");
                                  print("map call back!! ${mapData.googleMapData?.name}");

                                  setState(() {

                                  });
                                },
                                child: Container(
                                  child: Text(
                                    '지도',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: PRIMARY_COLOR
                                    ),
                                  ),
                                ),
                              ),



                            ],
                          ),
                        ],
                      ),
                    ),


                    Visibility(
                      visible: mapData.isChecked,
                      child: Column(
                        children: [
                          Text(
                            "${mapData.googleMapData?.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: GoogleMapPage(
                                  lat: mapData.googleMapData?.lat ?? 0,
                                  lng: mapData.googleMapData?.lng ?? 0,
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    mapData = GoogleMapCheck(
                                      isChecked: false,
                                      googleMapData: null,
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.pink,
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
*/


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*Future<Position> getCurrentLocation() async {

    print("지도 이동3");
    var _position = await Geolocator.getCurrentPosition(
      *//*  forceAndroidLocationManager: true,*//*
        desiredAccuracy: LocationAccuracy.high
    );


    print("지도 이동4 ${_position}");
    return _position ;
  }
  */

  void onSavedPressed(BuildContext context) async {
    if(!alarmChecked || DateTime(alarmDate.year,alarmDate.month,alarmDate.day,alarmTime.hour,alarmTime.minute)
        .isAfter(DateTime.now())){
      var notificationId = ("${Random().nextInt(9999)}${alarmDate.year}${alarmDate.month}${alarmDate.day}${alarmTime.hour}${alarmTime.minute}").hashCode;
      // var notificationId = Uuid().v4().hashCode;
      if (!isCompare(startTime, endTime) || !isSame(startTime, endTime)) {
        showToast('시작 시간과 종료 시간을 잘 적어주세요 (0시~24시)');
      } else if (contentController.text == null || contentController.text == "") {
        showToast("내용을 적어주세요.");
      } else {

        var event = provider.events;

        var start = int.parse('${startTime!.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}');
        var end = int.parse('${endTime!.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}');

        showToast("${start}  ${end}");

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
            alarmData: !alarmChecked? null: AlarmData(
              id: notificationId,
              alarmDate: int.parse('${alarmDate!.year.toString().padLeft(4, '0')}${alarmDate.month.toString().padLeft(2, '0')}${alarmDate.day.toString().padLeft(2, '0')}'),
              alarmTime: int.parse('${alarmTime!.hour.toString().padLeft(2, '0')}${alarmTime.minute.toString().padLeft(2, '0')}'),
            ),
          ),
        );

        print("onSavedPressed  $date");

        print("onSavedPressed event[date]  ${event[date]}");

        if (event[date] == null || event[date].isEmpty) {

          print("데이터 없음 저장하기");
          showToast('저장하기 ${root}');

          // 스케쥴 모델 파이어스토어에 삽입하기
         /* await FirebaseFirestore.instance
              .collection(
                root
              )
              .doc(schedule.id)
              .set(schedule.toJson())*/
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

              if(alarmChecked){
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
          for (var i=0; i < length; i++) {
            var data = event[date][i] as ScheduleModel;

            print("onSavedPressed i  ${data.startTime}  ${data.endTime}");

            print("onSavedPressed date  ${start}  ${end}");


            if (data.startTime < start && start < data.endTime) {
              showToast('저장하려는 시간에 스케줄이 있어요!');
              break;
            } else if (data.startTime < end && end < data.endTime) {
              showToast('저장하려는 시간에 스케줄이 있어요!');
              break;
            } else {
              print("onSavedPressed else ${i}  ${event[date].length-1}");
              if(i == length-1){

                // 스케쥴 모델 파이어스토어에 삽입하기
                await FirebaseFirestore.instance
                    .collection('schedule')
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

                    if(alarmChecked){
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
                            alarmTime.minute
                        ),
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
    }else{
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
