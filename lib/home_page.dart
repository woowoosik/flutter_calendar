import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/calendar_week.dart';
import 'package:schedule_calendar/fcm/forground_notification.dart';
import 'package:schedule_calendar/login/login_page.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:schedule_calendar/schedule_detail_page.dart';
import 'package:schedule_calendar/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/main_calendar.dart';
import 'package:schedule_calendar/component/schedule_card.dart';
import 'package:schedule_calendar/component/today_banner.dart';
import 'model/schedule_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schedule_calendar/login/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late var provider;

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<CalendarProvider>(context, listen: false);

      getEventMarker();
      print("~ init  ");
      // getEventMarker();
      Provider.of<CalendarProvider>(context, listen: false).getEvents(events);
      print("~~ init");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@@@@@@@@ home_page build @@@@@@@@@@@@");
    provider = Provider.of<CalendarProvider>(context);

    const List<String> list = <String>['로그아웃', '탈퇴하기'];

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        shape: const CircleBorder(),
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          /*  showModalBottomSheet(   // 시트 열기
              context: context,
              isDismissible: true,    // 배경 탭했을 때 시트 닫기
              builder: (_) => ScheduleBottomSheet(),
          );*/
          /* Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => ScheduleBottomSheet()),
          );*/

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionsBuilder:
                  // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
                  // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
                  (context, animation, secondaryAnimation, child) {
                print("@@@@@@@@@@@@@@ 이것보다 먼저");
                // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
                // 애니메이션이 시작할 포인트 위치를 의미한다.
                // 애니메이션의 시작과 끝을 담당한다.
                /*var tween = Tween(
                  begin: const Offset(1, 1),
                  end: const Offset(0.0, 0.0),
                ).chain(
                  CurveTween(
                    curve: Curves.bounceInOut,
                  ),
                );*/
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
              // 함수를 통해 Widget을 pageBuilder에 맞는 형태로 반환하게 해야한다.
              pageBuilder: (context, animation, secondaryAnimation) =>
                  // (DetailScreen은 Stateless나 Stateful 위젯으로된 화면임)
                  ScheduleBottomSheet(
                selectedDate: selectedDate,
              ),
              // 이것을 true로 하면 dialog로 취급한다.
              // 기본값은 false
              fullscreenDialog: false,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Schedule Calendar'),
        actions: [
          Padding(
            padding: const EdgeInsets.only( right: 15.0),
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
                  if(str == list[0]){
                    await FirebaseAuth.instance.signOut();
                    moveLoginPage();
                  }else{
                    userDelete();
                  }
                }
            ),

          ),


/*
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {


              final user = FirebaseAuth.instance.currentUser;

              print("delete @1 : ${user}");

              print("delete 2");

              const CircularProgressIndicator();

              if(await emailCheck()){
                await user?.delete().then((value) => {

                  FirebaseFirestore.instance
                      .collection('schedule')
                      .doc(root)
                      .collection(root)
                      .get().then((value) {
                    for(var i in value.docs){
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
                    .delete().then((value) => moveLoginPage());

              }

              // await FirebaseAuth.instance.signOut();

            },





          ),*/
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
                        /*StreamBuilder<QuerySnapshot>(
                          // ListView에 적용했던 같은 쿼리
                          stream: FirebaseFirestore.instance
                              .collection(root)
                              .where(
                                'date',
                                isGreaterThanOrEqualTo: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    0,
                                    0,
                                    0),
                              )
                              .where(
                                'date',
                                isLessThanOrEqualTo: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    23,
                                    59,
                                    59,
                                    59),
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            return TodayBanner(
                              selectedDate: selectedDate,
                              // ➊ 개수 가져오기
                              count: snapshot.data?.docs.length ?? 0,
                            );
                          },
                        ),*/
                      TodayBanner(
                        selectedDate: selectedDate,
                        count: provider.events[selectedDate]
                            ==null
                            ? 0
                            : provider.events[selectedDate].length,
                      ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: /*StreamBuilder<QuerySnapshot>(
                            // ➊ 파이어스토어로부터 일정 정보 받아오기
                            stream: FirebaseFirestore.instance
                                .collection(root)
                                .where(
                                  'date',
                                  isGreaterThanOrEqualTo: DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      0,
                                      0,
                                      0),
                                )
                                .where(
                                  'date',
                                  isLessThanOrEqualTo: DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      23,
                                      59,
                                      59,
                                      59),
                                )
                                .orderBy('date', descending: false)
                                .orderBy('startTime', descending: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면

                              // ➋ ScheduleModel로 데이터 매핑하기

                              if (snapshot.hasData) {
                                print("데이터 있음");

                              } else if (snapshot.hasError) {
                                print("데이터 에러");
                                return const Center(
                                  child: Text('일정 정보를 가져오지 못했습니다.'),
                                );
                              }

                              // 로딩 중일 때 보여줄 화면
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final schedules = snapshot.data?.docs
                                  .map(
                                    (QueryDocumentSnapshot e) =>
                                        ScheduleModel.fromJson(
                                            json: (e.data()
                                                as Map<dynamic, dynamic>)),
                                  )
                                  .toList();

                              return ListView.builder(
                                itemCount: snapshot.data?.docs.length ?? 0,
                                itemBuilder: (context, index) {
                                  final schedule = schedules![index];

                                  return Dismissible(
                                    key: ObjectKey(schedule.id),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (DismissDirection direction) {
                                      //LocalNotification.notificationRemove(1);

                                      var k = DateTime.utc(
                                          schedule.date.year,
                                          schedule.date.month,
                                          schedule.date.day);

                                      provider.removeEvent(k, schedule.id);

                                      FirebaseFirestore.instance
                                          .collection(root)
                                          .doc(schedule.id)
                                          .delete();

                                      // provider.events.removeWhere((key, value) => key == k || value == schedule.id);
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
                                                      curve:
                                                          Curves.easeInOutCubic,
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
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          */


                          ListView.builder(
                            itemCount: provider.events[selectedDate]==null? 0:provider.events[selectedDate].length,
                            itemBuilder: (context, index) {

                              var events = provider.events[selectedDate]..sort((a, b) {
                                var s = a.startTime as int;
                                var e = b.startTime as int;
                                return s.compareTo(e) ;
                              });

                              print("events  ${events}");
                             // .sort((a,b) => a['date'].compareTo(b['date']));
                             // final schedule = schedules![index];
                              final schedule = events[index];
                              print("@@@@@@@@  ${schedule}");

                              return Dismissible(
                                key: ObjectKey(schedule.id),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (DismissDirection direction) {
                                  //LocalNotification.notificationRemove(1);

                                  var k = DateTime.utc(
                                      schedule.date.year,
                                      schedule.date.month,
                                      schedule.date.day);

                                  provider.removeEvent(k, schedule.id);

                                  FirebaseFirestore.instance
                                      .collection('schedule')
                                      .doc(root)
                                      .collection(root)
                                      .doc(schedule.id)
                                      .delete();

                                  // provider.events.removeWhere((key, value) => key == k || value == schedule.id);
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
                                                  curve:
                                                  Curves.easeInOutCubic,
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
  }

  Widget textWidget(String hint, Widget icon, dynamic controller){
    return Container(
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe6dfd8), Color(0xFFf7f5ec)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      child: TextField(
        controller: controller,
        expands: false,
        style: TextStyle(fontSize: 17.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: icon,
          hintText: hint ,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black26),
        ),
        keyboardType: TextInputType.text,
        onSubmitted: (value){
          // login();
        },

      ),

    );
  }

  Future<bool> emailCheck() async{

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
              textWidget('이메일을 입력해주세요.', const Icon(Icons.email_outlined), emailController),
              SizedBox(height: 5,),
              textWidget('비밀번호를 입력해주세요.', const Icon(Icons.lock_outline_rounded), passwordController),

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
                  print("${emailController.text}  ${passwordController.text}");
                  result = await userRecertification(emailController.text, passwordController.text);
                  print("result ! : ${result}");
                  if(result){
                    result = true;
                    Navigator.of(context).pop(); //창 닫기
                  }else{
                    Fluttertoast.showToast(
                        msg: '이메일, 비밀번호가 틀렸습니다.', gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_SHORT);
                  }
                },
                child: Text(
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
                child: Text(
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


    print("result !2 : ${result}");

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

  dynamic moveLoginPage(){
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
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
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginPage(),
        ),
            (route) => false);
  }

  Future<bool> userRecertification(String str, String password) async{
    var bool = false;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: str,
          password: password)
          .then((value) => {
            bool = true
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

    /*
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
*/
  }

/*

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    print('onDaySelected  ${selectedDate}  ${focusedDate}');
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

*/

  void onFormatChanged(
      DateTime selectedDate, DateTime focusedDate, dynamic format) {
    print('onFormatChanged  ${selectedDate}  ${focusedDate}  ${format}');
    setState(() {
      visible = format == CalendarFormat.week ? false : true;
    });
  }

  /*void onFormatSelected(DateTime selectedDate, DateTime focusedDate, dynamic format){
    print('onListenFormat  ${selectedDate}  ${format}');
    setState(() {
      format == CalendarFormat.week? visible=0:visible=1;
    });
  }*/

  void onPageChanged(
      DateTime selectedDate, DateTime focusedDate, DateTime focusedDay) async {
    setState(() {
      print("~~ onPageChanged ${selectedDate}  ${focusedDate}  ${focusedDay} ");
      weekDate = focusedDay;
    });
  }

/*
  List<dynamic> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }*/

  List<dynamic> getEventsForDay(DateTime day) {
   // print("^ getEventsForDay  ${provider.events}");
    return provider.events[day] ?? [];
  }

  Future<dynamic> getEventMarker() async {
    events = {};
   // print("getEventMarker ~");
    print("uid : ${FirebaseAuth.instance.currentUser!.uid}");
    print("root : ${root}");
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(root)
        .collection(root)
        .get()
        .then(
      (querySnapshot) {
        print("snapshot : ${querySnapshot}");

        var docs = querySnapshot.docs;
        print("docs length : ${docs?.length}");

        for (var data in docs!) {
          // var date = (data.data()['date'] as Timestamp).toDate();
          print("date : ${data.data()['id']}");
          print("date : ${data.data()['content']}");
          print("date : ${data.data()['date']}");
          var dateTimestamp = (data.data()['date'] as Timestamp).toDate();
          var date = DateTime.utc(
              dateTimestamp.year, dateTimestamp.month, dateTimestamp.day);
          var content = data.data()['content'];
          var startTime = data.data()['startTime'];
          var endTime = data.data()['endTime'];
          var id = data.data()['id'];
          var googleMapCheck = data.data()['googleMapCheck'];
          /*GoogleMapCheck(
                  isChecked: false,
                  googleMapData: GoogleMapData(
                    lng: 0.0,
                    formatted_address: "없음",
                    name: '없음',
                    lat: 0.0,
                  )
              );
*/
          var alarm = data.data()['alarm'];
          /* Alarm(
                  isChecked: false,
                  alarmData: AlarmData(
                      alarmDate: 11110101,
                      alarmTime: 11110102,
                      id: 1111
                  )
              );*/

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

        print("event :  ${events}");
      },
      onError: (e) => print("Error completing: $e"),
    );

    setState(() {});

    // Map<DateTime, List<dynamic>> events = {};

    /*StreamBuilder<QuerySnapshot>(

      // ListView에 적용했던 같은 쿼리
      stream: FirebaseFirestore.instance
          .collection('schedule',)
          .snapshots(),
      builder: (context, snapshot) {
        print("snapshot : ${snapshot}");

        var docs = snapshot.data?.docs;
        print("docs length : ${docs?.length}");

        for (var data in docs!) {
          // var date = (data.data()['date'] as Timestamp).toDate();

          var dateTimestamp = (data.data()['date'] as Timestamp).toDate();
          var date = DateTime.utc(dateTimestamp.year, dateTimestamp.month, dateTimestamp.day);
          var content = data.data()['content'];
          var startTime = data.data()['startTime'];
          var endTime = data.data()['endTime'];
          var id = data.data()['id'];

          if (events[date] == null) {
            events[date] = [];
          }

          var scheduleData = ScheduleModel(
            id: id,
            date: date,
            startTime: startTime,
            endTime: endTime,
            content: content,

          );
          events[date]?.add(scheduleData);
        }

        print("event :  ${events}");

       // return events
      },
    );

*/

/*
    setState(() {

    });*/

    return events;
  }




}








/*
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  var visible = true;

  var weekDate = DateTime.utc(
    1,1,1
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        shape: const CircleBorder(),
        backgroundColor: PRIMARY_COLOR,
        onPressed: (){
        */
/*  showModalBottomSheet(   // 시트 열기
              context: context,
              isDismissible: true,    // 배경 탭했을 때 시트 닫기
              builder: (_) => ScheduleBottomSheet(),
          );*/ /*

         */
/* Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => ScheduleBottomSheet()),
          );*/ /*


          Navigator.push(
            context,
            PageRouteBuilder(
              transitionsBuilder:
              // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
              // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
                  (context, animation, secondaryAnimation, child) {
                // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
                // 애니메이션이 시작할 포인트 위치를 의미한다.
                // 애니메이션의 시작과 끝을 담당한다.
                */
/*var tween = Tween(
                  begin: const Offset(1, 1),
                  end: const Offset(0.0, 0.0),
                ).chain(
                  CurveTween(
                    curve: Curves.bounceInOut,
                  ),
                );*/ /*

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
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
              // 함수를 통해 Widget을 pageBuilder에 맞는 형태로 반환하게 해야한다.
              pageBuilder: (context, animation, secondaryAnimation) =>
              // (DetailScreen은 Stateless나 Stateful 위젯으로된 화면임)
              ScheduleBottomSheet(),
              // 이것을 true로 하면 dialog로 취급한다.
              // 기본값은 false
              fullscreenDialog: false,

            ),
          );
        },
        child: Icon(Icons.add),
      ),
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
                  child: Text('${weekDate}'),
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
      weekDate = focusedDate;
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
  }*/ /*


  void onPageChanged(DateTime selectedDate, DateTime focusedDate, DateTime focusedday){
    print(" onPageChanged ${selectedDate}  ${focusedDate}  ${focusedday} ");

    setState(() {
      weekDate = focusedday;
    });
  }

}
*/
