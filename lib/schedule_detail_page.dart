import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:schedule_calendar/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ScheduleDetailPage extends StatefulWidget{

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

class _ScheduleDetailPage extends State<ScheduleDetailPage>{

  @override
  void initState() {
    super.initState();

    widget.startTime = TimeOfDay(
        hour: int.parse(widget.schedule.startTime.toString().padLeft(4, '0').substring(0, 2)),
        minute: int.parse(widget.schedule.startTime.toString().padLeft(4, '0').substring(2, 4))
    );
    widget.endTime = TimeOfDay(
        hour: int.parse(widget.schedule.endTime.toString().padLeft(4,'0').substring(0, 2)),
        minute: int.parse(widget.schedule.endTime.toString().padLeft(4,'0').substring(2, 4))
    );

    widget.alarmChecked = widget.schedule.alarm.isChecked;
    if(widget.schedule.alarm.isChecked){
      widget.alarmDate = DateTime(
        int.parse(widget.schedule.alarm.alarmData.alarmDate.toString().substring(0, 4)),
        int.parse(widget.schedule.alarm.alarmData.alarmDate.toString().substring(4, 6)),
        int.parse(widget.schedule.alarm.alarmData.alarmDate.toString().substring(6, 8)),
      );
      widget.alarmTime = TimeOfDay(
          hour: int.parse(widget.schedule.alarm.alarmData.alarmTime.toString().padLeft(4,'0').substring(0, 2)),
          minute: int.parse(widget.schedule.alarm.alarmData.alarmTime.toString().padLeft(4,'0').substring(2, 4))
      );
    }

    widget.contentController.text = widget.schedule.content;

    widget.mapChecked = widget.schedule.googleMapCheck.isChecked;
    if(widget.schedule.googleMapCheck.isChecked){
      widget.mapData = widget.schedule.googleMapCheck;
    }

  }


  @override
  Widget build(BuildContext context) {

    widget.provider = Provider.of<CalendarProvider>(context);


    print("#################  navigator ###############################");
    print(
        "######  ${widget.schedule.startTime} ###############################");
    print(
        "######  ${widget.schedule.endTime} ###############################");
    print(
        "######  ${widget.schedule.content} ###############################");
    print("######  ${widget.schedule.id} ###############################");



    print("######  ${widget.schedule.googleMapCheck?.isChecked} ###############################");
    print("######  ${widget.schedule.googleMapCheck!.googleMapData?.name} ###############################");
    print("######  ${widget.schedule.googleMapCheck!.googleMapData?.lat} ###############################");
    print("######  ${widget.schedule.googleMapCheck!.googleMapData?.lng} ###############################");
    print("######  ${widget.schedule.googleMapCheck!.googleMapData?.formatted_address} ###############################");

    /*   if(schedule.googleMapCheck.googleMapData != null){
                print("######  ${schedule.googleMapCheck?.googleMapData!.name} ###############################");
                print("######  ${schedule.googleMapCheck?.googleMapData!.lat} ###############################");
                print("######  ${schedule.googleMapCheck?.googleMapData!.lng} ###############################");
                print("######  ${schedule.googleMapCheck?.googleMapData!.formatted_address} ###############################");

              }*/

    print("######  ${widget.schedule.alarm?.isChecked} ###############################");
    print("######  ${widget.schedule.alarm?.alarmData?.id} ###############################");
    print("######  ${widget.schedule.alarm?.alarmData?.alarmDate} ###############################");
    print("######  ${widget.schedule.alarm?.alarmData?.alarmTime} ###############################");

    print("#####################################");






    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              // 패딩에 키보드 높이 추가해서 위젯 전반적으로 위로 올려주기
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(
                children: [
                  Padding(
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
                          "${widget.schedule.date.year}"
                              " - ${widget.schedule.date.month.toString().padLeft(2, '0')}"
                              " - ${widget.schedule.date.day.toString().padLeft(2, '0')}",
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
                            '수정',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
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
                              initialTime: widget.startTime,
                            );
                            if (timeOfDay != null) {
                              setState(() {
                                widget.startTime = timeOfDay;
                              });
                            }
                          },
                          child: Text(
                            '${widget.startTime.hour}:${widget.startTime.minute.toString().padLeft(2, '0')}',
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
                              initialTime: widget.endTime,
                            );
                            if (timeOfDay != null) {
                              setState(() {
                                widget.endTime = timeOfDay;
                              });
                            }
                          },
                          child: Text(
                            '${widget.endTime.hour}:${widget.endTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                              visible: !widget.alarmChecked,
                              child: const Text(
                                "푸시알림",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Visibility(
                              visible: widget.alarmChecked,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? dateTime = await showDatePicker(
                                          context: context,
                                          initialDate: widget.alarmDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(9999));
                                      if (dateTime != null) {
                                        setState(() {
                                          widget.alarmDate = dateTime;
                                        });
                                      }
                                    },
                                    child: Text(
                                      '${widget.alarmDate.year}-${widget.alarmDate.month.toString().padLeft(2, '0')}-${widget.alarmDate.day.toString().padLeft(2, '0')}',
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
                                        initialTime: widget.alarmTime,
                                      );
                                      if (timeOfDay != null) {
                                        setState(() {
                                          widget.alarmTime = timeOfDay;
                                        });
                                      }
                                    },
                                    child: Text(
                                      '(${widget.alarmTime.hour}:${widget.alarmTime.minute.toString().padLeft(2, '0')})',
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
                              value: widget.alarmChecked,
                              onChanged: (value) {
                                setState(() {
                                  widget.alarmChecked = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
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
                            GestureDetector(
                              onTap: () async {
                                if(await checkPermission()){
                                  widget.mapData = await Navigator.push(context,
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
                                                  /*mapData = GoogleMapData(
                                                    isChecked: false,
                                                    lat: 0.0,
                                                    lng: 0.0,
                                                    name: "",
                                                    formatted_address: "",
                                                  );*/
                                                  return GoogleMapAddress(position: s.data, mapData: widget.mapData);
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
                    visible: widget.mapData.isChecked,
                    child: Column(
                      children: [
                        Text(
                          "${widget.mapData.googleMapData?.name}",
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
                                lat: widget.mapData.googleMapData?.lat ?? 0,
                                lng: widget.mapData.googleMapData?.lng ?? 0,
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  widget.mapData = GoogleMapCheck(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<Position> getCurrentLocation() async {
    var _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return _position ;
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

    if(!widget.alarmChecked
        || DateTime(
            widget.alarmDate.year,
            widget.alarmDate.month,
            widget.alarmDate.day,
            widget.alarmTime.hour,
            widget.alarmTime.minute
        ).isAfter(DateTime.now())){
      var notificationId = ("${Random().nextInt(9999)}${widget.alarmDate.year}${widget.alarmDate.month}${widget.alarmDate.day}${widget.alarmTime.hour}${widget.alarmTime.minute}").hashCode;
      // var notificationId = Uuid().v4().hashCode;
      if (!isCompare(widget.startTime, widget.endTime) || !isSame(widget.startTime, widget.endTime)) {
        showToast('시작 시간과 종료 시간을 잘 적어주세요 (0시~24시)');
      } else if (widget.contentController.text == null || widget.contentController.text == "") {
        showToast("내용을 적어주세요.");
      } else {

        var event = widget.provider.events;

        var start = int.parse('${widget.startTime!.hour.toString().padLeft(2, '0')}${widget.startTime.minute.toString().padLeft(2, '0')}');
        var end = int.parse('${widget.endTime!.hour.toString().padLeft(2, '0')}${widget.endTime.minute.toString().padLeft(2, '0')}');

        showToast("${start}  ${end}");

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
            alarmData: !widget.alarmChecked? null: AlarmData(
              id: notificationId,
              alarmDate: int.parse('${widget.alarmDate!.year.toString().padLeft(4, '0')}${widget.alarmDate.month.toString().padLeft(2, '0')}${widget.alarmDate.day.toString().padLeft(2, '0')}'),
              alarmTime: int.parse('${widget.alarmTime!.hour.toString().padLeft(2, '0')}${widget.alarmTime.minute.toString().padLeft(2, '0')}'),
            ),
          ),
        );

        print("onSavedPressed  $date");

        print("onSavedPressed event[date]  ${event[date]}");

        if (event[date] == null || event[date].isEmpty) {

          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");
          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");
          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");
          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");
          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");
          print("@@@@@@@@@@@@@@@ if   ${event[date]} @@@@@@@@@@@@@@@");

/*

          print("데이터 없음 저장하기");
          showToast('저장하기');
          await FirebaseFirestore.instance
              .collection('schedule')
              .doc(widget.schedule.id)
              .delete()
              .then((value) async {
                // 스케쥴 모델 파이어스토어에 삽입하기
                await FirebaseFirestore.instance
                    .collection(
                  'schedule',
                )
                    .doc(schedule.id)
                    .set(schedule.toJson())
                    .then((value) async {
                  print("${date}  ${schedule}");



                  var s = FCMController();
                  var token = await FirebaseMessaging.instance.getToken();


                  if(widget.alarmChecked){
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
                        widget.alarmTime.minute,
                      ),
                      delete: false,
                    );
                  }

                  if(widget.schedule.alarm.isChecked){
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
                          widget.alarmTime.minute
                      ),
                      delete: true,
                    );
                  }


                  Navigator.of(context).pop();

                });


              }
          );


*/




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

                await FirebaseFirestore.instance
                    .collection('schedule')
                    .doc(root)
                    .collection(root)
                    .doc(widget.schedule.id)
                    .update(schedule.toJson())
                    .then((value) async {

                    print("지울꺼 : ${widget.schedule.id}");
                    print("지울꺼 : ${widget.schedule.startTime}");
                    print("지울꺼 : ${widget.schedule.endTime}");
                    print("지울꺼 : ${widget.schedule.date}");
                    print("지울꺼 : ${widget.schedule.content}");


                    var s = FCMController();
                    var token = await FirebaseMessaging.instance.getToken();

                    if(widget.alarmChecked){
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
                            widget.alarmTime.minute
                        ),
                        delete: false,
                      );
                    }

                    // 전 알림 지우기
                    if(widget.schedule.alarm.isChecked){
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
                            widget.alarmTime.minute
                        ),
                        delete: true,
                      );
                    }

                    await widget.provider.removeEvent(date, widget.schedule.id);
                    await widget.provider?.addEvent(date, schedule);
                    print("처리 한 후 : ${event[date]}");
                    Navigator.of(context).pop();

/*

                  // 74500a32-9ceb-4fba-b567-b9d1410d9eac

                      // 스케쥴 모델 파이어스토어에 삽입하기
                      await FirebaseFirestore.instance
                          .collection(
                        root,
                      )
                          .doc(schedule.id)
                          .set(schedule.toJson())
                          .then((value) async {

                        print("${date}  ${schedule}");

                        var s = FCMController();
                        var token = await FirebaseMessaging.instance.getToken();

                        if(widget.alarmChecked){
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
                                widget.alarmTime.minute
                            ),
                            delete: false,
                          );
                        }

                        // 전 알림 지우기
                        if(widget.schedule.alarm.isChecked){
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
                                widget.alarmTime.minute
                            ),
                            delete: true,
                          );
                        }


                        await widget.provider.removeEvent(date, widget.schedule.id);
                        await widget.provider?.addEvent(date, schedule);

                        print("처리 한 후 : ${event[date]}");
                        Navigator.of(context).pop();

                      });
                      // 일정 생성 후 화면 뒤로 가기

                  */



                    }





                );







              }

            }
          }


        }
      }
    }else{

      showToast("알람시간을 현재시간보다 높게 조정해주세요");
    }
  }



}


void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_SHORT);
}


