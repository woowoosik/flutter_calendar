import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_calendar/color/colorList.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/model/schedule_model.dart';


class MainCalendar extends StatefulWidget{

  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  var onFormatChanged;
  var onPageChanged;

  var getEventsForDay;


  var colorCnt = 0;

  MainCalendar({required this.getEventsForDay, required this.onDaySelected, required this.selectedDate, required this.onFormatChanged, required this.onPageChanged});

  @override
  State<StatefulWidget> createState() {
    return _mainCalendar(onDaySelected, selectedDate, onFormatChanged, onPageChanged);
  }
}

class _mainCalendar extends State<MainCalendar>{


  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;

  OnDaySelected onDaySelected;
  DateTime selectedDate;
  var onFormatChanged;
  var onPageChanged;



  _mainCalendar(this.onDaySelected, this.selectedDate, this.onFormatChanged, this.onPageChanged);

/*  Map<DateTime, List<String>> events = {
    DateTime.utc(2024,3,25) : [  ('title'),  ('title2') , ('title'),  ('title2'), ('title'),('title'),  ('title2') , ('title'),  ('title2'), ('title'),  ],
    DateTime.utc(2024,3,14) : [  ('title3') ],
  };*/

  /*List<dynamic> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }*/




  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      firstDay: DateTime.utc(1900, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),

      calendarStyle: const CalendarStyle(
        // today 표시 여부
        isTodayHighlighted : true,

        // today 글자 조정
        todayTextStyle : TextStyle(
          color: DARK_PRIMARY_COLOR,
          fontWeight: FontWeight.bold
        ),

        // today 모양 조정
        todayDecoration : BoxDecoration(
          color: transparent,
          shape: BoxShape.circle,
        ),

        // selectedDay 모양 조정
        selectedDecoration : BoxDecoration(
          color: PRIMARY_COLOR,
          shape: BoxShape.circle,
        ),


        markersAlignment: Alignment.center,


      ),

      eventLoader: widget.getEventsForDay ,

      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {     // 선택된 날짜 구분할 로직
        return isSameDay(selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {  // 날짜 선택 시 실핼할 함수

        print("@!onDaySelected  select : ${selectedDate}   focus : ${_focusedDay}  " );
        onDaySelected(selectedDay, focusedDay );
        if (!isSameDay(selectedDate, selectedDay)) {
          setState(() {
            selectedDate = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },

      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),

      formatAnimationCurve: Curves.easeInOutCirc,
      formatAnimationDuration: Duration(milliseconds: 200),
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        print("@!onFormatChanged  select : ${selectedDate}   focus : ${_focusedDay}  " );
        onFormatChanged(_focusedDay, selectedDate, format);

        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }


      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        print("@!onPageChanged  select : ${selectedDate}   focus : ${_focusedDay}  focusDay : ${_focusedDay} " );
        onPageChanged(_focusedDay, selectedDate, focusedDay);

        _focusedDay = focusedDay;

      },


      calendarBuilders: CalendarBuilders(
        markerBuilder: (BuildContext context, date, events) {
          if (events.isEmpty) return SizedBox();
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    // height: 7, // for vertical axis
                    width: 10, // for horizontal axis
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorList[
                          color(widget.colorCnt)
                        ],
                    ),
                  ),
                );
              });
        },

        defaultBuilder: (context, day, focusDay) {
          if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }else if(day.weekday == DateTime.saturday){
            return Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
        },
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            return const Center(
              child: Text(
                '일',
                style: TextStyle(color: Colors.red),
              ),
            );
          }else if(day.weekday == DateTime.saturday){
            return const Center(
              child: Text(
                "토",
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
        },

      ),




    );
  }


  dynamic color(int colorCnt){
    print("color  nu1 ${colorCnt}");
    if(colorCnt >= colorList.length-1){
      widget.colorCnt = 0;
    }else{
      widget.colorCnt++;
    }

    print("color  nu2 ${colorCnt}");
    return widget.colorCnt;
  }
}
