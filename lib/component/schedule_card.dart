import 'package:flutter/cupertino.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/schedule_detail_page.dart';

class ScheduleCard extends StatelessWidget{
  final int startTime;
  final int endTime;
  final String content;
  final schedule;

  const ScheduleCard({required this.schedule, required this.startTime, required this.endTime, required this.content, Key? key}):super(key: key);


  @override
  Widget build(BuildContext context) {


    print("################  ScheduleCard  ################################");
    print(
        "######  ${schedule.startTime} ###############################");
    print(
        "######  ${schedule.endTime} ###############################");
    print(
        "######  ${schedule.content} ###############################");
    print("######  ${schedule.id} ###############################");



    print("######  ${schedule.googleMapCheck?.isChecked} ###############################");
    print("######  ${schedule.googleMapCheck?.googleMapData?.name} ###############################");
    print("######  ${schedule.googleMapCheck?.googleMapData?.lat} ###############################");
    print("######  ${schedule.googleMapCheck?.googleMapData?.lng} ###############################");
    print("######  ${schedule.googleMapCheck?.googleMapData?.formatted_address} ###############################");


    print("######  ${schedule.alarm?.isChecked} ###############################");
    print("######  ${schedule.alarm?.alarmData?.id} ###############################");
    print("######  ${schedule.alarm?.alarmData?.alarmDate} ###############################");
    print("######  ${schedule.alarm?.alarmData?.alarmTime} ###############################");

    print("#####################################");


    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(
          8.0
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(     // 높이를 내부 위젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(schedule: schedule,),
              SizedBox(width: 16.0,),
              _Content(content: content,),
              SizedBox(width: 16.0,)
            ],
          ),
        ),
      ),
    );
  }
}


class _Time extends StatelessWidget{
  final schedule;

  const _Time({required this.schedule, Key? key}):super(key:key);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );


    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${schedule.startTime.toString().padLeft(4,'0').substring(0,2)}:${schedule.startTime.toString().padLeft(4,'0').substring(2,4)}',
            style: textStyle,
          ),
          Text(
            '${schedule.endTime.toString().padLeft(4,'0').substring(0,2)}:${schedule.endTime.toString().padLeft(4,'0').substring(2,4)}',
            style: textStyle.copyWith(fontSize: 10.0),
          ),

        ],
      );
  }
}

class _Content extends StatelessWidget{
  final String content;

  const _Content({required this.content, Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}