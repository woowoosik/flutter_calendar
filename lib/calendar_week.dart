import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_calendar/color/colorList.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
import 'package:schedule_calendar/provider/calendar_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:schedule_calendar/schedule_detail_page.dart';
import 'package:touchable/touchable.dart';

class CalendarWeek extends StatefulWidget {
  final weekDate;

  const CalendarWeek({super.key, required this.weekDate});

  @override
  State<StatefulWidget> createState() {
    return _CalendarWeek();
  }
}

class _CalendarWeek extends State<CalendarWeek> with TickerProviderStateMixin {
  late var provider;
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 400.0,
  );


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CalendarProvider>(context);
    print("calendar week build");
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: CanvasTouchDetector(
          gesturesToOverride: const [
            GestureType.onTapDown,
            GestureType.onPanUpdate,
            GestureType.onPanDown,
            GestureType.onTapUp
          ],
          builder: (context) => CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 2),
            painter: WeekPainter(
                weekDate: widget.weekDate,
                provider: provider,
                context: context),
          ),
        ),
      ),
    );
  }
}

class WeekPainter extends CustomPainter {
  final weekDate;
  final provider;
  final BuildContext context;

  WeekPainter(
      {required this.weekDate, required this.provider, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // 색
      ..color = Colors.black12
      // 선의 끝은 각지게 표현
      ..strokeCap = StrokeCap.square
      // 선의 굵기
      ..strokeWidth = 1.0;

    var height = size.height.toDouble() / 24;

    for (var i = 0; i < 24; i++) {
      Offset p1 = Offset(0, height * i.toDouble());
      Offset p2 = Offset(size.width.toDouble(), height * i.toDouble());
      canvas.drawLine(p1, p2, paint);

      TextSpan span = TextSpan(
          style: const TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
          text: i.toString());
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(0, height * i.toDouble()));
    }

    Paint schedulePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 40.0;

    var scheduleWidth = size.width / 7;

    var scheduleHeight = size.height.toDouble() / 1440;

    var day = getSunDay(weekDate);


    var myCanvas = TouchyCanvas(context, canvas);

    var colorCnt = 0;

    for (var i = 1; i < 8; i++) {
      var weekDay = day.add(Duration(days: i - 1));

      if (provider.events[weekDay] != null) {
        for (var schedule in provider.events[weekDay]) {

          if(colorCnt >= colorList.length-1){
            colorCnt = 0;
          }else{
            colorCnt++;
          }

          var startHour = double.parse(
              schedule.startTime.toString().padLeft(4, '0').substring(0, 2));
          var startMinute = double.parse(
              schedule.startTime.toString().padLeft(4, '0').substring(2, 4));
          var endHour = double.parse(
              schedule.endTime.toString().padLeft(4, '0').substring(0, 2));
          var endMinute = double.parse(
              schedule.endTime.toString().padLeft(4, '0').substring(2, 4));

          myCanvas.drawRRect(
            RRect.fromLTRBR(
                scheduleWidth * i - scheduleWidth + scheduleWidth / 7,
                (scheduleHeight * 60) * startHour.toDouble() +
                    scheduleHeight * startMinute,
                scheduleWidth * i - scheduleWidth / 7,
                (scheduleHeight * 60) * endHour.toDouble() +
                    scheduleHeight * endMinute, Radius.circular(7)),
            schedulePaint
              ..color = colorList[colorCnt],
            onTapUp: (tapdetail) {

              navigator(context, schedule);
            },

          );
        }


      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

DateTime getSunDay(DateTime d) {
  switch (intl.DateFormat('E', 'ko_KR').format(d)) {
    case '월':
      return d.subtract(Duration(days: 1));
    case '화':
      return d.subtract(Duration(days: 2));
    case '수':
      return d.subtract(Duration(days: 3));
    case '목':
      return d.subtract(Duration(days: 4));
    case '금':
      return d.subtract(Duration(days: 5));
    case '토':
      return d.subtract(Duration(days: 6));
    default:
      return d;
  }
}

dynamic navigator(BuildContext context, dynamic schedule) {

  return Navigator.push(
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
      pageBuilder: (context, animation, secondaryAnimation) =>
          ScheduleDetailPage(schedule: schedule),
    ),
  );
}
