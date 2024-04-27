import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule_calendar/color/colorList.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/schedule_detail_page.dart';

class ScheduleCard extends StatelessWidget{
  final int startTime;
  final int endTime;
  final String content;
  final schedule;
  final index;

  const ScheduleCard({required this.schedule, required this.startTime, required this.endTime, required this.content, required this.index, Key? key}):super(key: key);


  @override
  Widget build(BuildContext context) {

    var colorIndex = (((schedule.date as DateTime).day + index) % 10) as int;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IntrinsicHeight(     // 높이를 내부 위젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: colorList[colorIndex],
              ),
              SizedBox(width: 16.0,),
              _Time(schedule: schedule, colorIndex: colorIndex,),
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
  final colorIndex;

  const _Time({required this.schedule, Key? key, required this.colorIndex}):super(key:key);

  @override
  Widget build(BuildContext context) {


    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
    );


    return Row(
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${schedule.startTime.toString().padLeft(4,'0').substring(0,2)}:${schedule.startTime.toString().padLeft(4,'0').substring(2,4)}',
                style: textStyle.copyWith(color: colorList[colorIndex]),
              ),
              Text(
                '${schedule.endTime.toString().padLeft(4,'0').substring(0,2)}:${schedule.endTime.toString().padLeft(4,'0').substring(2,4)}',
                style: textStyle.copyWith(fontSize: 12.0),
              ),

            ],
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
    return Expanded(
        child: Text(
            content,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
    );
  }
}